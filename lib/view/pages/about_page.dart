import 'package:flutter/material.dart';
import 'package:veguide/view/widgets/app_title.dart';

/// About page, showing info about the app.
class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("A propos :", style: Theme.of(context).primaryTextTheme.titleMedium),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                children: [
                  buildTextSpan(
                      context: context, highlight: true, text: "Veguide"),
                  buildTextSpan(
                      context: context,
                      highlight: false,
                      text: " est une application "),
                  buildTextSpan(
                      context: context, highlight: true, text: "gratuite "),
                  buildTextSpan(
                      context: context,
                      highlight: false,
                      text: "au service de la communauté végane. \n"
                          "Son but est de faciliter la "),
                  buildTextSpan(
                      context: context,
                      highlight: true,
                      text: "recherches de points de restauration végans "),
                  buildTextSpan(
                      context: context,
                      highlight: false,
                      text: "selon vos exigeances, sans avoir à décortiquer les menus et avis en amont.\n"
                          "Si l'application vous plait, ou si vous avez des suggestions, faites-le nous savoir dans la section "),
                  buildTextSpan(
                      context: context, highlight: true, text: "Contact"),
                  buildTextSpan(context: context, highlight: false, text: "."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats a [TextSpan] depending on whether the text has to be [highlight]ed or not.
  TextSpan buildTextSpan(
          {required BuildContext context,
          required bool highlight,
          required text}) =>
      TextSpan(
          text: text,
          style: highlight
              ? Theme.of(context).primaryTextTheme.bodyLarge
              : Theme.of(context).primaryTextTheme.bodyMedium);
}
