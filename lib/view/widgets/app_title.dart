import 'package:flutter/material.dart';
import 'package:veguide/view/styles.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Veguide",
      style: Theme.of(context).primaryTextTheme.headlineLarge,
    );
  }
}
