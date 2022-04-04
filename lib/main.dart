import 'package:flutter/material.dart';
import 'package:veguide/view/root.dart';
import 'package:veguide/view/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veguide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.green[700],
        secondary: Colors.green.shade700),
        primaryTextTheme: TextTheme(titleMedium: TextStyle(color: Colors.black))
      ),
      home: const Root(title: 'Veguide'),
    );
  }
}

