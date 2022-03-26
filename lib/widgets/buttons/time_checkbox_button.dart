import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:inqvine_core_ui/inqvine_core_ui.dart';

class TimeCheckboxButton extends StatelessWidget {
  const TimeCheckboxButton({
    required this.onTap,
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final Widget control = Checkbox(
      value: value,
      onChanged: (_) {},

      // activeColor: activeColor,
      // checkColor: checkColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      // autofocus: autofocus,
      // tristate: tristate,
      // side: side,
    );
    return InqvineTapHandler(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            IgnorePointer(child: control),
          ],
        ),
      ),
    );
  }
}
