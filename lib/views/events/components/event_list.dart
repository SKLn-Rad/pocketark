import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/widgets/tiles/event_tile.dart';

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
        return EventTile(event: event);
      },
    );
  }
}
