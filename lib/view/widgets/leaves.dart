import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:flutter/animation.dart';
import 'package:veguide/view/styles.dart';

class Leaves extends StatefulWidget {
  Leaves({Key? key, required this.leavesController}) : super(key: key);

  LeavesController leavesController;

  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> with TickerProviderStateMixin {
  Map<int, AnimationController> _animControllers ={};

  @override
  void initState() {
    super.initState();
    if(widget.leavesController.clickable){
      _animControllers[1] = _createAnimationController();
      _animControllers[2] = _createAnimationController();
      _animControllers[3] = _createAnimationController();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leaves = [];
    for(var i=1; i <= 3; i++ ){
      leaves.add(
      widget.leavesController.clickable
          ? _createAnimatedLeaf(i)
          : _createStaticLeaf(i)
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: leaves,
    );
  }

  Widget _createAnimatedLeaf(int level) =>
      IconButton(
        icon: ScaleTransition(
          scale: _animControllers[level]!,
          child: Icon(Icons.eco_rounded,
            color: widget.leavesController.leafLevel >= level
                ? deepGreen
                : black,
            size: 30,
          ),
        ),
        onPressed: () {
          _animate(level);
          widget.leavesController.leafLevel = level;
          setState(() {});
        },
        constraints: BoxConstraints(),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      );


  Widget _createStaticLeaf(int level)=>
      Icon(Icons.eco_rounded,
      color: widget.leavesController.leafLevel >= level
          ? deepGreen // Selected
          : black,
      size: 30, // Not selected
    );

  AnimationController _createAnimationController()=> AnimationController(
    duration: const Duration(milliseconds: 125), vsync: this,
    value: 1.0,
    lowerBound: 1.0,
    upperBound: 1.75,);

  /// Animates leaves that are equal of of inferior value as the leaf clicked
  /// (represented by its [level]).
  void _animate(int level){
    _animControllers.forEach((leafLevel, controller) {
      if(leafLevel <= level){
        controller.forward().then((value) => controller.reverse());
      }
    });
  }
}
