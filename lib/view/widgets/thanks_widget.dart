import 'package:flutter/material.dart';
class ThanksWidget extends StatelessWidget {
  const ThanksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Merci pour votre suggestion !",
            style: Theme.of(context).primaryTextTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Center(
          child: Text(
            "Un email vous sera envoyé dès qu'elle sera traitée.",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Retour à l'application")),
        )
      ],
    );;
  }
}
