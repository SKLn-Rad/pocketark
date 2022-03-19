// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pocketark/views/home/state/home_view_model.dart';
import '../../../extensions/context_extensions.dart';
import '../../../resources/resources.dart';
import '../../../constants/design_constants.dart';
import '../../../widgets/scaffolds/pocketark_scaffold.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeViewModel viewModel = useViewModel(ref, () => HomeViewModel());
    return PocketArkScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          PocketArkImages.logoLetter,
          height: kAppBarIconHeight,
        ),
      ),
      body: Container(),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        currentIndex: viewModel.currentHomeIndex,
        onTap: (int index) => viewModel.currentHomeIndex = index,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.home_outline),
            label: context.localizations?.pageHomeNavBarLabelHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.calendar_clear_outline),
            label: context.localizations?.pageHomeNavBarLabelEvents,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.settings_outline),
            label: context.localizations?.pageHomeNavBarLabelSettings,
          ),
        ],
      ),
    );
  }
}
