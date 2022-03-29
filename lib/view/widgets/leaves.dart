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
  late AnimationController scaleAnimationController;
  // late AnimationController colorAnimController;

  // late Animation colorAnimation;
  // late Animation scaleAnimation;


  @override
  void initState() {
    super.initState();

    scaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 125), vsync: this,
    value: 1.0,
    lowerBound: 1.0,
    upperBound: 1.75,);
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        createLeaf(1),
        createLeaf(2),
        createLeaf(3),
      ],
    );
  }

  Widget createLeaf(int level) =>
      IconButton(
        icon: ScaleTransition(
          scale: scaleAnimationController,
          child: Icon(Icons.eco_rounded,
            color: widget.leavesController.leafLevel >= level
                ? Colors.green.shade500 // Selected
                : Colors.black.withOpacity(0.5),
            size: 30, // Not selected
          ),
        ),
        onPressed: widget.leavesController.clickable ? () {
          scaleAnimationController.forward().then((value) => scaleAnimationController.reverse());
          setState(() {
            widget.leavesController.leafLevel = level;
          });
        }
            : null,
        constraints: BoxConstraints(),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      );
}
