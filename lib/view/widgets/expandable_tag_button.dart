import 'package:flutter/material.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/view/styles.dart';


class ExpandableTagButton extends StatefulWidget {
  ExpandableTagButton({Key? key, required this.tag}) : super(key: key);
  Tag tag;

  @override
  _ExpandableTagButtonState createState() => _ExpandableTagButtonState();
}

class _ExpandableTagButtonState extends State<ExpandableTagButton>
    with SingleTickerProviderStateMixin {
  static const size = 30.0;
  static const padding = 8.0;

  bool _isExpanded = false;

  // late AnimationController _animationController;
  double width = size+padding*2;
  String text = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _animationController = AnimationController(
    //   duration: const Duration(milliseconds: 125), vsync: this,
    //   value: 1.0,
    //   lowerBound: 1.0,
    //   upperBound: 1.75,);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: AnimatedContainer(
            color: Theme.of(context).primaryColor,
            width: width,
            duration: Duration(milliseconds: 300),
            curve: Curves.decelerate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: padding, vertical: 5.0),
              child: InkWell(
                child: Row(
                  children: [
                  Icon(
                  widget.tag.icon,
                  size: size,
                  color: grey,),
                    Text(text, style: TextStyle(color: grey),),
                  ],
                ),
                onTap: () {
                  setState(() {
                    if (_isExpanded) {
                      width = size+padding*2;
                      text = "";
                    }else{
                      text = widget.tag.name;
                      // Horrible code: Animation only works with defined width value.
                      //  Therefore, I calculate the necessary width based on the text, with
                      //  hard-coded value for each tag. It's lame, I know.
                      width = text.length*widget.tag.width + padding*2;
                    }
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

// void _animate(){
//   if(_isExpanded){
//     _animationController.forward();
//   }else{
//     _animationController.reverse();
//   }
//
// }
}
