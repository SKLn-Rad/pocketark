import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/constants/design_constants.dart';
import 'package:pocketark/proto/events.pb.dart';
import 'package:pocketark/extensions/event_extensions.dart';

class EventTile extends StatefulWidget {
  const EventTile({
    required this.event,
    this.isLargeFormat = true,
    this.isExpanded = false,
    Key? key,
  }) : super(key: key);

  final LostArkEvent event;
  final bool isLargeFormat;
  final bool isExpanded;

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                height: 72.0,
                width: 72.0,
                color: kGrayLighter,
              ),
            ),
            kSpacingSmall.asWidthWidget,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "[${widget.event.recItemLevel}] ${widget.event.fallbackName}",
                    style: context.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  kSpacingTiny.asHeightWidget,
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Next ${widget.event.getEventTypeAsString(context)} in: ",
                          style: context.textTheme.caption!.copyWith(color: Colors.green),
                        ),
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
    );
  }
}
