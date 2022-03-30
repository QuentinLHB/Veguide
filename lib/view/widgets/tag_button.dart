import 'package:flutter/material.dart';
import 'package:veguide/view/styles.dart';

class TagButton extends StatefulWidget {
  TagButton({Key? key, required this.onPressed, this.icon, this.text, required this.isToggled})
      : super(key: key);
  VoidCallback onPressed;
  IconData? icon;
  String? text;
  bool isToggled;

  @override
  _TagButtonState createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {


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
            MaterialStateProperty.all<Color>(widget.isToggled ? deepGreen : grey),
        foregroundColor: MaterialStateProperty.all<Color>(widget.isToggled ? grey : deepGreen),
      ),


    );
  }
}
