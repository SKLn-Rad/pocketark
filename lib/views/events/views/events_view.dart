import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pocketark/views/events/components/event_list.dart';

import '../../../constants/design_constants.dart';
import '../../../extensions/context_extensions.dart';
import '../../../proto/events.pb.dart';
import '../../../views/events/state/events_view_model.dart';
import '../../../widgets/scaffolds/pocketark_appbar.dart';
import '../../../widgets/scaffolds/pocketark_scaffold.dart';

class EventsView extends HookConsumerWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EventsViewModel viewModel = useViewModel(ref, () => EventsViewModel());
    return PocketArkScaffold(
      appBar: PocketArkAppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () => viewModel.onSetDateRequested(context),
            icon: const Icon(Ionicons.time_outline),
          ),
        ],
      ),
      body: ListView(
        padding: kSpacingLarge.asPaddingAll,
        children: <Widget>[
          Text(
            context.localizations?.pageEventsComponentsEventsCaptionShownDate(viewModel.shownDateTime.ddMMyyyy) ?? '',
            textAlign: TextAlign.center,
            style: context.textTheme.caption!.copyWith(
              color: kGrayLight,
            ),
          ),
          kSpacingMedium.asHeightWidget,
          EventList(viewModel: viewModel),
          context.devicePadding.bottom.asHeightWidget,
        ],
      ),
    );
  }
}
