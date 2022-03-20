import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../views/events/state/events_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../proto/events.pb.dart';

class EventList extends StatelessWidget {
  const EventList({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final EventsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: viewModel.filteredEvents.length,
      separatorBuilder: (_, __) => kSpacingMedium.asHeightWidget,
      itemBuilder: (_, int index) {
        final LostArkEvent event = viewModel.filteredEvents[index];
        return EventListTile(event: event);
      },
    );
  }
}

class EventListTile extends StatelessWidget {
  const EventListTile({
    required this.event,
    Key? key,
  }) : super(key: key);

  final LostArkEvent event;

  @override
  Widget build(BuildContext context) {
    final String scheduleTitle = '[${event.recItemLevel}] ${event.fallbackName.toUpperCase()}';
    final List<DateTime> scheduleRawTimes = event.schedule.map((e) => DateTime.fromMillisecondsSinceEpoch(e.timeStart.toInt())).toList();
    final String scheduleTimeString = scheduleRawTimes.map((e) => e.ddMMyyyy).join(' / ');

    return Container(
      width: double.infinity,
      padding: kSpacingSmall.asPaddingAll,
      decoration: BoxDecoration(
        borderRadius: 8.0.asBorderRadiusCircular,
        color: kGrayLight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  scheduleTitle,
                  style: context.textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                ),
                kSpacingTiny.asHeightWidget,
                Text(
                  '-00:03:01',
                  style: context.textTheme.caption!.copyWith(color: Colors.orange),
                ),
                kSpacingTiny.asHeightWidget,
                Text(
                  scheduleTimeString,
                  style: context.textTheme.caption!.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
