import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veguide/view/styles.dart';

class SuggestionField extends StatefulWidget {
  SuggestionField(
      {Key? key,
      this.mandatory = false,
      this.isNumber = false,
      this.charLimit = 100,
      this.isMultiLine = false,
      this.screenRatio = 1,
      required this.text,
      required this.hint,
      required this.controller})
      : super(key: key);

  bool mandatory;
  int charLimit;
  String text;
  String hint;
  TextEditingController controller;
  bool isNumber;
  int screenRatio;
  bool isMultiLine = false;

  @override
  _SuggestionFieldState createState() => _SuggestionFieldState();
}

class _SuggestionFieldState extends State<SuggestionField> {
  @override
  Widget build(BuildContext context) {
    Widget textWidget = widget.mandatory
        ? RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: widget.text,
                    style: Theme.of(context).primaryTextTheme.bodyMedium),
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 18)),
                // TextSpan(text: " :", style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          )
        : Text(widget.text,
            style: Theme.of(context).primaryTextTheme.bodyMedium);

    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget,
        createTextField(),
      ],
    );
  }

  Widget createTextField() {
    TextInputType? inputType;
    if (widget.isNumber) {
      inputType = TextInputType.number;
    } else if (widget.isMultiLine) {
      inputType = TextInputType.multiline;
    }
    TextField textField = TextField(
      controller: widget.controller,
      maxLength: widget.charLimit,
      keyboardType: inputType,
      maxLines: widget.isMultiLine ? 3 : 1,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 14)),
    );

    if (widget.screenRatio == 1) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: textField,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: widget.screenRatio == 1
            ? Expanded(child: textField)
            : Container(
                width: MediaQuery.of(context).size.width / widget.screenRatio,
                child: textField,
              ),
      );
    }
  }
}
