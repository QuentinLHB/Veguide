import 'package:flutter/material.dart';
import 'package:veguide/controller/controller.dart';
import 'package:veguide/view/root.dart';
import 'package:veguide/view/styles.dart';

void main() {
  Controller();
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
            primary: Colors.green[700], secondary: Colors.green.shade700),
        primaryTextTheme: TextTheme(
            headlineLarge:TextStyle(fontSize: 28, fontFamily: 'SweetyRasty', color: Colors.white),
          titleLarge: TextStyle(fontSize: 20, color: Colors.green.shade700, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Colors.green.shade700, fontSize: 16),
          titleSmall: TextStyle(color: Colors.green.shade700, fontSize: 15, fontStyle: FontStyle.italic),
          bodyLarge: TextStyle(color: Colors.green.shade700, fontSize: 15),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 15),
            labelSmall: TextStyle(fontSize: 14, color: Colors.green.shade700, fontStyle: FontStyle.italic),
        ),
        primaryColor: Colors.green.shade700,
        hintColor: Colors.black.withOpacity(0.4),
        unselectedWidgetColor: Colors.green.shade700,
      ),
      home: const Root(title: 'Veguide'),
    );
  }
}
