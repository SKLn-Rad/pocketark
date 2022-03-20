import 'package:flutter/material.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

import '../../../constants/design_constants.dart';
import '../../../proto/events.pb.dart';
import '../../../views/home/state/home_view_model.dart';
import '../../../widgets/indicators/pocketark_loading_indicator.dart';

class HomeComponentPagerEvents extends StatelessWidget {
  const HomeComponentPagerEvents({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.eventService.events.isEmpty) {
      return const Center(
        child: PocketArkLoadingIndicator(),
      );
    }

    return ListView(
      padding: kSpacingLarge.asPaddingAll,
      children: <Widget>[
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel.allEvents.length,
          separatorBuilder: (_, __) => kSpacingMedium.asHeightWidget,
          itemBuilder: (_, int index) {
            final LostArkEvent event = viewModel.allEvents[index];
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
                          '[${event.recItemLevel}] ${event.fallbackName.toUpperCase()}',
                          style: context.textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        kSpacingTiny.asHeightWidget,
                        Text(
                          '-00:03:01',
                          style: context.textTheme.caption!.copyWith(color: Colors.orange),
                        ),
                        kSpacingTiny.asHeightWidget,
                        Text(
                          '07:20 / 08:20 / 09:20 / 10:20 / 11:20 / 12:20 / 13:20 / 14:20 / 15:20 / 16:20 / 17:20 / 18:20 / 19:20 / 20:20 / 21:20 / 22:20 / 23:20',
                          style: context.textTheme.caption!.copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
