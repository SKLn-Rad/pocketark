import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    this.colour,
    this.child,
    this.borderColour,
  }) : super(key: key);

  final Color? colour;

  final Color? borderColour;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CardTheme cardTheme = CardTheme.of(context);
    final bool hasBorder = borderColour != null ? true : false;

    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: hasBorder ? borderColour! : (cardTheme.color ?? theme.cardColor),
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: colour ?? cardTheme.color ?? theme.cardColor,
      ),
      child: child,
    );
  }
}
