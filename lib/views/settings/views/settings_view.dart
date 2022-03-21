import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:inqvine_core_ui/inqvine_core_ui.dart';
import 'package:pocketark/views/settings/components/settings_card_notifications_settings.dart';

import '../../../constants/application_constants.dart';
import '../../../extensions/context_extensions.dart';
import '../../../views/settings/state/settings_view_model.dart';
import '../../../widgets/scaffolds/pocketark_appbar.dart';
import '../../../widgets/scaffolds/pocketark_scaffold.dart';
import '../../../constants/design_constants.dart';
import '../../../resources/resources.dart';
import '../components/settings_card_filter_settings.dart';
import '../components/settings_card_system_settings.dart';

class SettingsView extends HookConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsViewModel viewModel = useViewModel(ref, () => SettingsViewModel());
    return PocketArkScaffold(
      appBar: const PocketArkAppBar(),
      body: ListView(
        padding: kSpacingLarge.asPaddingAll,
        children: <Widget>[
          // SettingsCardFilterSettings(viewModel: viewModel),
          // kSpacingMedium.asHeightWidget,
          SettingsCardNotificationsSettings(viewModel: viewModel),
          kSpacingMedium.asHeightWidget,
          SettingsCardSystemSettings(viewModel: viewModel),
          kSpacingExtraLarge.asHeightWidget,
          InqvineTapHandler(
            isEnabled: !viewModel.isBusy,
            onTap: () => viewModel.systemService.openUrl(kUrlInqvine),
            child: Column(
              children: <Widget>[
                Center(
                  child: SvgPicture.asset(
                    PocketArkImages.inqvine,
                    height: kAppBarIconHeight,
                  ),
                ),
                kSpacingSmall.asHeightWidget,
                Text(
                  context.localizations?.pageSettingsComponentSettingsCreatorBody ?? '',
                  textAlign: TextAlign.center,
                  style: context.textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
