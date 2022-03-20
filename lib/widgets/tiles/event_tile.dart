import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../extensions/event_extensions.dart';
import '../../../constants/design_constants.dart';
import '../../../proto/events.pb.dart';

class EventTile extends StatefulWidget {
  const EventTile({
    required this.event,
    this.isLargeFormat = true,
    this.isExpanded = false,
    this.isMuted = false,
    Key? key,
  }) : super(key: key);

  final LostArkEvent event;
  final bool isLargeFormat;
  final bool isExpanded;
  final bool isMuted;

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  static const double kImageRadius = 72.0;

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
    final String nextEventCaption = 'Next ${widget.event.getEventTypeAsString(context)} in:';

    return AnimatedOpacity(
      duration: kBasicAnimationDuration,
      opacity: widget.isMuted ? kDisabledOpacity : kEnabledOpacity,
      child: Card(
        child: Container(
          width: double.infinity,
          padding: kSpacingSmall.asPaddingAll,
          child: Row(
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
                    image: NetworkImage("https://lostarkcodex.com/icons/" + widget.event.iconPath),
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
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: nextEventCaption,
                            style: context.textTheme.caption!.copyWith(color: Colors.green),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: widget.event.getNextEventTimeAsString,
                            style: context.textTheme.caption!.copyWith(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                    kSpacingTiny.asHeightWidget,
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          for (LostArkEvent_LostArkEventSchedule schedule in widget.event.schedule) ...<TextSpan>[
                            TextSpan(
                              text: schedule.getEventStartTimeAsString,
                              style: context.textTheme.caption!.copyWith(color: schedule.getScheduleColour),
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
          ),
        ),
      ),
    );
  }
}
