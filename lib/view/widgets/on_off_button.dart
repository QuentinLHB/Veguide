import 'package:flutter/material.dart';
import 'package:veguide/view/styles.dart';

class OnOffButton extends StatefulWidget {
  OnOffButton({Key? key, required this.onPressed, this.icon, this.text, required this.isToggled})
      : super(key: key);
  VoidCallback onPressed;
  IconData? icon;
  String? text;
  bool isToggled;

  @override
  _OnOffButtonState createState() => _OnOffButtonState();
}

class _OnOffButtonState extends State<OnOffButton> {


  @override
  Widget build(BuildContext context) {
    List<Widget> buttonContent = [];
    if (widget.icon != null) {
      buttonContent.add(Icon(widget.icon!));
      buttonContent.add(const SizedBox(width: 5,));

    }
    if (widget.text != null) buttonContent.add(Text(widget.text!));

    return ElevatedButton(
      onPressed: (){widget.onPressed();
      setState(() {
        widget.isToggled = !widget.isToggled;
      });},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: buttonContent,
      ),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(widget.isToggled ? Theme.of(context).primaryColor : grey),
        foregroundColor: MaterialStateProperty.all<Color>(widget.isToggled ? grey : Theme.of(context).primaryColor),
      ),


    );
  }
}
