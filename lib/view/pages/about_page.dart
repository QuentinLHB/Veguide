import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veguide/view/widgets/app_title.dart';
import 'package:veguide/view/widgets/fav_button.dart';
import 'package:veguide/view/styles.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTitle(),
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("A propos :", style: styleH3),
          ),
          Text("Veguide est une application gratuite au service de la communauté végane. "
              "Elle a été développée par Quentin Lehembre.")
        ],
      ),
    );
  }
}