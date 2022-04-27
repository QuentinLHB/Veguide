import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veguide/view/styles.dart';

class SuggestionField extends StatefulWidget {
  SuggestionField(
      {Key? key,
      this.mandatory = false,
      this.isNumber = false,
      this.charLimit = 100,
        this.lines = 3,
      this.isMultiLine = false,
      this.screenRatio = 1,
      required this.text,
      required this.hint,
      required this.controller})
      : super(key: key);


  bool mandatory;
  int charLimit;
  int lines;
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
  int get maxLines{
    if(!widget.isMultiLine) return 1;
    return widget.lines;
  }

  @override
  Widget build(BuildContext context) {
    Widget textWidget = widget.mandatory
        ? RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: widget.text.isEmpty ? "" : widget.text + " :",
                    style: Theme.of(context).primaryTextTheme.bodyMedium),
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 18)),
                // TextSpan(text: " :", style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          )
        : Text(widget.text.isEmpty ? "" : widget.text + " :",
            style: Theme.of(context).primaryTextTheme.bodyMedium);

    if(widget.isMultiLine){
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: textWidget,
          ),
          Row(
            children: [
              createTextField(),
            ],
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
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
      maxLines: maxLines,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
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
        child: Container(
                width: MediaQuery.of(context).size.width / widget.screenRatio,
                child: textField,
              ),
      );
    }
  }
}
