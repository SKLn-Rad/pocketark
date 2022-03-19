import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PocketArkLoadingIndicator extends StatelessWidget {
  const PocketArkLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitDancingSquare(color: Colors.white);
  }
}
