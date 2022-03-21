import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:inqvine_core_ui/inqvine_core_ui.dart';

import '../../../views/events/components/event_list.dart';
import '../../../constants/application_constants.dart';
import '../../../widgets/indicators/pocketark_loading_indicator.dart';
import '../../../constants/design_constants.dart';
import '../../../extensions/context_extensions.dart';
import '../../../views/events/state/events_view_model.dart';
import '../../../widgets/scaffolds/pocketark_appbar.dart';
import '../../../widgets/scaffolds/pocketark_scaffold.dart';

class EventsView extends HookConsumerWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EventsViewModel viewModel = useViewModel(ref, () => EventsViewModel());

    return PocketArkScaffold(
      isBusy: viewModel.isBusy,
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
                const PopupMenuDivider(),
                PopupMenuItem<EventDropdownAction>(
                  value: EventDropdownAction.disableAllGlobalEventAlarms,
                  onTap: () => viewModel.onDropdownActionSelected(context, EventDropdownAction.disableAllGlobalEventAlarms),
                  child: Text(EventDropdownAction.disableAllGlobalEventAlarms.toLocale(context)),
                ),
                PopupMenuItem<EventDropdownAction>(
                  value: EventDropdownAction.enableAllGlobalEventAlarms,
                  onTap: () => viewModel.onDropdownActionSelected(context, EventDropdownAction.enableAllGlobalEventAlarms),
                  child: Text(EventDropdownAction.enableAllGlobalEventAlarms.toLocale(context)),
                ),
                PopupMenuItem<EventDropdownAction>(
                  value: EventDropdownAction.toggleHideEventsWithoutAlarms,
                  onTap: () => viewModel.onDropdownActionSelected(context, EventDropdownAction.toggleHideEventsWithoutAlarms),
                  child: Text(EventDropdownAction.toggleHideEventsWithoutAlarms.toLocale(context, meta: viewModel.hideEventsWithoutAlarms)),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
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
              ],
            ),
          ),
          InqvineConditionalAutoHide(
            isShown: viewModel.applicationService.mobileSplashBannerAd != null,
            child: Container(
              height: kAdvertHeight + (kSpacingTiny * 2),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: kSpacingTiny),
              alignment: Alignment.center,
              color: context.theme.primaryColor,
              child: viewModel.applicationService.mobileSplashBannerAd != null ? AdWidget(ad: viewModel.applicationService.mobileSplashBannerAd!) : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
