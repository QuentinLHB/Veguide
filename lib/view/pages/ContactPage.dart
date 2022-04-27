import 'package:flutter/material.dart';
import 'package:veguide/tools.dart';
import 'package:veguide/view/widgets/app_title.dart';
import 'package:veguide/view/widgets/ask_email.dart';
import 'package:veguide/view/widgets/suggestion_field.dart';
import 'package:veguide/view/widgets/thanks_widget.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController _emailController = TextEditingController();
  bool _wantsEmail = false;
  bool _isSent = false;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppTitle(),
      ),
      body: _isSent
          ? ThanksWidget()
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Une remarque, une suggestion, un bug ? Envoyez votre message ci-dessous, et indiquez votre email si vous souhaitez une réponse.\n"
                      "Si vous souhaitez suggérer un restaurant, un formulaire est présent dans la page 'Suggérer un restaurant'. \n"
                      "Pour suggérer une modification, cliquez sur 'Suggérer une modification' sur le restaurant en question.",
                      style: Theme.of(context).primaryTextTheme.titleSmall),
                  SizedBox(
                    height: 20,
                  ),
                  AskEmail(
                      onTap: () {
                        _wantsEmail = !_wantsEmail;
                      },
                      emailFieldController: _emailController),
                  SuggestionField(
                    text: "",
                    hint: "Message à l'intention de l'administrateur",
                    controller: _commentController,
                    isMultiLine: true,
                    lines: 8,
                    charLimit: 1000,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_wantsEmail && _emailController.text.isEmpty) {
                          showErrorDialog("Envoi impossible", "Veuillez renseigner votre adresse mail.");
                          return;
                        }
                        if(_commentController.text.isEmpty){
                          showErrorDialog("Message vide", "Veuillez renseigner un message.");
                          return;
                        }
                        setState(() {
                          _isSent = true;
                        });
                        //TODO: Envoi à la bdd
                      },
                      child: Text("Envoyer")),
                ],
              ),
            ),
    );
  }

  void showErrorDialog(String title, String text){
    Tools.showAnimatedDialog(
        context: context,
        title: title,
        content: Text(text),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text('OK'),
          ),
        ]);
  }
}
