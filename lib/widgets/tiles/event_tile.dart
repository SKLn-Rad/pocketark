import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:inqvine_core_ui/inqvine_core_ui.dart';
import 'package:pocketark/services/event_service.dart';
import 'package:pocketark/widgets/tiles/event_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../extensions/event_extensions.dart';
import '../../../constants/design_constants.dart';
import '../../../proto/events.pb.dart';
import '../../constants/application_constants.dart';

import 'package:pocketark/extensions/context_extensions.dart';

class EventTile extends StatefulWidget {
  const EventTile({
    required this.event,
    this.isLargeFormat = true,
    this.isExpanded = false,
    this.isGlobalAlarmActive = false,
    Key? key,
  }) : super(key: key);

  final LostArkEvent event;
  final bool isLargeFormat;
  final bool isExpanded;
  final bool isGlobalAlarmActive;

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  static const double kImageRadius = 72.0;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  set isExpanded(bool val) {
    _isExpanded = val;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final String nextEventCountdown = widget.event.getNextEventTimeAsString;
    final String nextEventCaption = nextEventCountdown.isNotEmpty ? context.localizations!.pageEventsTileCaptionNextEventIn(widget.event.getEventTypeAsString(context)) : context.localizations!.pageEventsTileCaptionNoMoreEvents;
    final String enableGlobalAlarmLabel = !widget.isGlobalAlarmActive ? context.localizations!.pageEventsComponentsAppBarActionsEnableRepeatingAlarm : context.localizations!.pageEventsComponentsAppBarActionsDisableRepeatingAlarm;
    final EventService eventService = inqvine.getFromLocator<EventService>();

    return InqvineTapHandler(
      onTap: () => isExpanded = !isExpanded,
      //! re-add this once InqvineTapHandler is updated
      // opacityTarget: 1.0,
      child: EventCard(
        borderColour: widget.isGlobalAlarmActive ? kHighlightColor : null,
        child: Padding(
          padding: kSpacingSmall.asPaddingAll,
          child: InqvineConditionalExpanded(
            isExpanded: isExpanded,
            collapsedChild: _EventTileHeader(kImageRadius: kImageRadius, widget: widget, nextEventCaption: nextEventCaption),
            expandedChild: Column(
              children: <Widget>[
                _EventTileHeader(kImageRadius: kImageRadius, widget: widget, nextEventCaption: nextEventCaption),
                kSpacingSmall.asHeightWidget,
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: kSpacingSmall,
                    runSpacing: kSpacingSmall,
                    children: <Widget>[
                      MaterialButton(
                        color: kTertiaryColor,
                        onPressed: () => eventService.toggleEventGlobalAlarm(widget.event),
                        child: Text(enableGlobalAlarmLabel),
                      ),
                      for (LostArkEvent_LostArkEventSchedule schedule in widget.event.schedule) ...<Widget>[
                        if (schedule.isEventInFuture)
                          CheckboxListTile(
                            value: eventService.isSingleAlarmActive(widget.event, schedule),
                            title: Text(schedule.getEventStartTimeAsString),
                            secondary: const Icon(Icons.timelapse_outlined),
                            onChanged: (_) => eventService.toggleAlarm(widget.event, schedule),
                          ),
                      ]
                      // MaterialButton(
                      //   color: kTertiaryColor,
                      //   onPressed: widget.onSetAlarm,
                      //   child: Text(enableNextAlarmLabel),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventTileHeader extends StatelessWidget {
  const _EventTileHeader({
    Key? key,
    required this.kImageRadius,
    required this.widget,
    required this.nextEventCaption,
  }) : super(key: key);

  final double kImageRadius;
  final EventTile widget;
  final String nextEventCaption;

  @override
  Widget build(BuildContext context) {
    final EventService eventService = inqvine.getFromLocator<EventService>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            height: kImageRadius,
            width: kImageRadius,
            color: kGrayLighter,
            child: FadeInImage(
              image: NetworkImage('$kEventIconPrefix${widget.event.iconPath}'),
              placeholder: MemoryImage(kTransparentImage),
            ),
          ),
        ),
        kSpacingSmall.asWidthWidget,
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.event.eventNameWithItemLevel,
                style: context.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
              ),
              kSpacingTiny.asHeightWidget,
              _EventTileTimer(nextEventCaption: nextEventCaption, widget: widget),
              kSpacingTiny.asHeightWidget,
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    for (LostArkEvent_LostArkEventSchedule schedule in widget.event.schedule) ...<TextSpan>[
                      TextSpan(
                        text: schedule.getEventStartTimeAsString,
                        style: context.textTheme.caption!.copyWith(color: eventService.getScheduleColour(widget.event, schedule)),
                      ),
                      if (widget.event.schedule.last != schedule)
                        TextSpan(
                          text: " / ",
                          style: context.textTheme.caption!.copyWith(color: kGrayLighter),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventTileTimer extends StatefulWidget {
  const _EventTileTimer({
    Key? key,
    required this.nextEventCaption,
    required this.widget,
  }) : super(key: key);

  final String nextEventCaption;
  final EventTile widget;

  @override
  State<_EventTileTimer> createState() => _EventTileTimerState();
}

class _EventTileTimerState extends State<_EventTileTimer> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    setupTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void setupTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: widget.nextEventCaption,
            style: context.textTheme.caption!.copyWith(color: Colors.green),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: widget.widget.event.getNextEventTimeAsString,
            style: context.textTheme.caption!.copyWith(color: Colors.yellow),
          ),
        ],
      ),
    );
  }
}
