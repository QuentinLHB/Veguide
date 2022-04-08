import 'package:flutter/material.dart';

import 'suggestion_field.dart';
class AskEmail extends StatefulWidget {
  AskEmail({Key? key, required this.onTap, required this.emailFieldController }) : super(key: key);

  TextEditingController emailFieldController;
Function() onTap;

  @override
  _AskEmailState createState() => _AskEmailState();
}

class _AskEmailState extends State<AskEmail> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(value: _value, onChanged: (newValue){
                  setState(() {
                    widget.onTap();
                    _value = !_value;
                    // widget.value = newValue!;
                  });
                },
                  activeColor: Theme.of(context).primaryColor,),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text("Recevoir une réponse par mail"),
              ),
            ],
          ),
          onTap:(){
            setState(() {
              widget.onTap();
              _value = !_value;
            });},
        ),
        SizedBox(height: 10.0,),
        _value ? SuggestionField(
          text: "Votre email",
          hint: "utilisateur@gmail.com",
          controller: widget.emailFieldController,
          mandatory: true,
          charLimit: 50,
        ) : SizedBox.shrink(),
      ],
    );
  }
}
