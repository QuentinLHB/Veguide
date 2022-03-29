import 'package:flutter/material.dart';

class TagButton extends StatefulWidget {
  TagButton({Key? key, required this.onPressed, this.icon, this.text})
      : super(key: key);
  VoidCallback onPressed;
  IconData? icon;
  String? text;

  @override
  _TagButtonState createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {
  bool _isToggled = false;

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
        _isToggled = !_isToggled;
      });},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: buttonContent,
      ),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(_isToggled ? Colors.green.shade500 : Colors.grey.shade200),
        foregroundColor: MaterialStateProperty.all<Color>(_isToggled ? Colors.grey.shade200 : Colors.green.shade500),
      ),


    );
  }
}
