import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veguide/view/styles.dart';
class FieldWidget extends StatefulWidget {
  FieldWidget({Key? key, this.mandatory = false, this.isNumber=false, this.charLimit = 100, this.isMultiLine = false, this.screenRatio = 1, required this.text, required this.controller}) : super(key: key);

  bool mandatory;
  int charLimit;
  String text;
  TextEditingController controller;
  bool isNumber;
  int screenRatio;
  bool isMultiLine = false;

  @override
  _FieldWidgetState createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  @override
  Widget build(BuildContext context) {
    Widget textWidget = widget.mandatory
        ? RichText(text: TextSpan(
      children: [
        TextSpan(text: widget.text, style: Theme.of(context).textTheme.titleMedium),
        TextSpan(text: " *", style: TextStyle(color: Colors.red, fontSize: 18)),
        // TextSpan(text: " :", style: Theme.of(context).textTheme.titleMedium),
      ],
    ),) :
    Text(widget.text, style: Theme.of(context).textTheme.titleMedium);

    return
      Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: textWidget,
        ),
        createTextField(),
      ],)
    ;
  }

  Widget createTextField(){
    TextInputType? inputType;
    if(widget.isNumber){
      inputType = TextInputType.number;
    }
    else if(widget.isMultiLine){
      inputType = TextInputType.multiline;
    }
    TextField textField = TextField(controller: widget.controller,
      maxLength: widget.charLimit,
      keyboardType: inputType,
    maxLines: widget.isMultiLine ? 3 : 1,);

    if(widget.screenRatio == 1){
      return  Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: textField,
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child:
        widget.screenRatio == 1
            ? Expanded(child: textField)
            : Container(
          width: MediaQuery.of(context).size.width/widget.screenRatio,
          child: textField,
        ),
      );
    }
  }
}
