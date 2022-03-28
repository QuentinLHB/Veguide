import 'package:flutter/material.dart';
import 'package:veguide/view/root.dart';

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
        primarySwatch: Colors.green,
        // TODO: Set a font family
      ),
      home: const Root(title: 'Veguide'),
    );
  }
}

