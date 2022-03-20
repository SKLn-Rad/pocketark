import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../proto/events.pb.dart';
import '../../../views/events/state/events_view_model.dart';
import '../../../constants/design_constants.dart';
import '../../../extensions/event_extensions.dart';
import '../../../widgets/tiles/event_tile.dart';

class EventList extends StatelessWidget {
  const EventList({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final EventsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final List<LostArkEvent> localFilteredEvents = <LostArkEvent>[
      ...viewModel.filteredEvents,
    ];

    // Perform Text Search
    final String searchText = viewModel.searchText.toLowerCase();
    if (searchText.isNotEmpty) {
      localFilteredEvents.removeWhere((element) => !element.eventNameWithItemLevel.toLowerCase().contains(searchText));
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: localFilteredEvents.length,
      separatorBuilder: (_, __) => kSpacingMedium.asHeightWidget,
      itemBuilder: (_, int index) {
        final LostArkEvent event = localFilteredEvents[index];
        return EventTile(event: event);
      },
    );
  }
}
