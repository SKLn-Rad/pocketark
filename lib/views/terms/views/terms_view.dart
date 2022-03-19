// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import '../../../constants/application_constants.dart';
import '../../../constants/design_constants.dart';
import '../../../constants/legal_constants.dart';
import '../../../extensions/context_extensions.dart';
import '../../../views/terms/state/terms_view_model.dart';
import '../../../widgets/scaffolds/pocketark_scaffold.dart';

class TermsView extends HookConsumerWidget {
  const TermsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TermsViewModel viewModel = useViewModel(ref, () => TermsViewModel());
    return PocketArkScaffold(
      appBar: AppBar(
        title: const Text(kApplicationName),
      ),
      body: ListView(
        padding: kSpacingMedium.asPaddingAll,
        children: <Widget>[
          Markdown(
            data: kTermsOfUse,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            onTapLink: (_, String? url, __) => viewModel.systemService.openUrl(url ?? ''),
          ),
          kSpacingLarge.asHeightWidget,
          Markdown(
            data: kPrivacyPolicy,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            onTapLink: (_, String? url, __) => viewModel.systemService.openUrl(url ?? ''),
          ),
          kSpacingLarge.asHeightWidget,
          CupertinoButton(
            color: context.theme.primaryColor,
            child: Text(context.localizations?.pageLegalButtonContinue ?? ''),
            onPressed: viewModel.onTermsAccepted,
          ),
          kSpacingSmall.asHeightWidget,
        ],
      ),
    );
  }
}
