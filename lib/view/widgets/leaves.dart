import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:flutter/animation.dart';

class Leaves extends StatefulWidget {
  Leaves({Key? key, required this.leavesController}) : super(key: key);

  LeavesController leavesController;

  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> with TickerProviderStateMixin {
  Map<int, AnimationController> animControllers ={};
  // late AnimationController colorAnimController;

  // late Animation colorAnimation;
  // late Animation scaleAnimation;


  @override
  void initState() {
    super.initState();
    if(widget.leavesController.clickable){
      animControllers[1] = createAnimationController();
      animControllers[2] = createAnimationController();
      animControllers[3] = createAnimationController();
    }

    // scaleAnimation;
    // colorAnimController = AnimationController(
    //     duration: const Duration(milliseconds: 125), vsync: this);
    // colorAnimation = ColorTween(
    //     begin: Colors.black.withOpacity(0.5),
    //     end: Colors.green.shade500
    // ).animate(colorAnimController)
    //   ..addListener(() {
    //     setState(() {});
    //   });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leaves = [];
    for(var i=1; i <= 3; i++ ){
      leaves.add(
      widget.leavesController.clickable
          ? createAnimatedLeaf(i)
          : createStaticLeaf(i)
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: leaves,
    );
  }

  Widget createAnimatedLeaf(int level) =>
      IconButton(
        icon: ScaleTransition(
          scale: animControllers[level]!,
          child: Icon(Icons.eco_rounded,
            color: widget.leavesController.leafLevel >= level
                ? Colors.green.shade500 // Selected
                : Colors.black.withOpacity(0.5),
            size: 30, // Not selected
          ),
        ),
        onPressed: () {
          animate(level);
          widget.leavesController.leafLevel = level;
          setState(() {});
        },
        constraints: BoxConstraints(),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      );


  Widget createStaticLeaf(int level)=>
      Icon(Icons.eco_rounded,
      color: widget.leavesController.leafLevel >= level
          ? Colors.green.shade500 // Selected
          : Colors.black.withOpacity(0.5),
      size: 30, // Not selected
    );

  AnimationController createAnimationController()=> AnimationController(
    duration: const Duration(milliseconds: 125), vsync: this,
    value: 1.0,
    lowerBound: 1.0,
    upperBound: 1.75,);

  /// Animates leaves that are equal of of inferior value as the leaf clicked
  /// (represented by its [level]).
  void animate(int level){
    animControllers.forEach((leafLevel, controller) {
      if(leafLevel <= level){
        controller.forward().then((value) => controller.reverse());
      }
    });
  }
}
