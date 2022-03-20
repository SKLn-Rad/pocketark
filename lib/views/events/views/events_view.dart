import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:inqvine_core_ui/inqvine_core_ui.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pocketark/views/events/components/event_list.dart';

import '../../../constants/application_constants.dart';
import '../../../widgets/indicators/pocketark_loading_indicator.dart';
import '../../../constants/design_constants.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/event_extensions.dart';
import '../../../proto/events.pb.dart';
import '../../../views/events/state/events_view_model.dart';
import '../../../widgets/scaffolds/pocketark_appbar.dart';
import '../../../widgets/scaffolds/pocketark_scaffold.dart';
import '../../../widgets/tiles/event_tile.dart';

class EventsView extends HookConsumerWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EventsViewModel viewModel = useViewModel(ref, () => EventsViewModel());

    return PocketArkScaffold(
      appBar: PocketArkAppBar(
        actions: <Widget>[
          PopupMenuButton<EventDropdownAction>(
            itemBuilder: (_) {
              return <PopupMenuEntry<EventDropdownAction>>[
                PopupMenuItem<EventDropdownAction>(
                  value: EventDropdownAction.selectDate,
                  onTap: () => viewModel.onDropdownActionSelected(context, EventDropdownAction.selectDate),
                  child: Text(EventDropdownAction.selectDate.toLocale(context)),
                ),
                PopupMenuItem<EventDropdownAction>(
                  value: EventDropdownAction.muteAllEvents,
                  onTap: () => viewModel.onDropdownActionSelected(context, EventDropdownAction.muteAllEvents),
                  child: Text(EventDropdownAction.muteAllEvents.toLocale(context)),
                ),
                PopupMenuItem<EventDropdownAction>(
                  value: EventDropdownAction.unmuteAllEvents,
                  onTap: () => viewModel.onDropdownActionSelected(context, EventDropdownAction.unmuteAllEvents),
                  child: Text(EventDropdownAction.unmuteAllEvents.toLocale(context)),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView(
        padding: kSpacingLarge.asPaddingAll,
        children: <Widget>[
          Text(
            context.localizations?.pageEventsComponentsEventsCaptionShownDate(viewModel.selectedDate.ddMMyyyy) ?? '',
            textAlign: TextAlign.center,
            style: context.textTheme.caption!.copyWith(
              color: kGrayLight,
            ),
          ),
          InqvineTapHandler(
            onTap: () => viewModel.systemService.openUrl(kUrlLostArkTimer),
            child: Text(
              context.localizations?.pageEventsComponentsEventsCaptionPoweredBy ?? '',
              textAlign: TextAlign.center,
              style: context.textTheme.caption!.copyWith(
                color: kPrimaryColor,
              ),
            ),
          ),
          kSpacingMedium.asHeightWidget,
          if (viewModel.filteredEvents.isEmpty && viewModel.isBusy) ...<Widget>[
            const PocketArkLoadingIndicator(),
          ],
          if (viewModel.filteredEvents.isNotEmpty) ...<Widget>[
            TextFormField(
              controller: viewModel.searchController,
              onChanged: (String val) => viewModel.searchText = val,
              decoration: InputDecoration(
                hintText: context.localizations?.pageEventsComponentsEventsTooltipsSearch ?? '',
              ),
            ),
            kSpacingMedium.asHeightWidget,
            EventList(viewModel: viewModel),
          ],
          context.devicePadding.bottom.asHeightWidget,
        ],
      ),
    );
  }
}
