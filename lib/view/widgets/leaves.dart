import 'package:flutter/material.dart';
import 'package:veguide/view/widgets/leaves_controller.dart';
import 'package:flutter/animation.dart';
import 'package:veguide/tools.dart';
import 'package:veguide/view/styles.dart';

class Leaves extends StatefulWidget {
  Leaves({Key? key, required this.leavesController, required this.clickable, this.isLarge = false})
      : super(key: key);

  LeavesController leavesController;
  bool isLarge;
  bool clickable;

  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> with TickerProviderStateMixin {
  Map<int, AnimationController> _animControllers = {};

  double get size => widget.isLarge ? 40 : 30;

  double get padding => widget.isLarge ? 3 : 1;
  static const helpIconSize = 24.0;

  @override
  void initState() {
    super.initState();
    if (widget.clickable) {
      _animControllers[1] = _createAnimationController();
      _animControllers[2] = _createAnimationController();
      _animControllers[3] = _createAnimationController();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leaves = [];
    for (var i = 1; i <= 3; i++) {
      leaves.add(
          widget.clickable
              ? _createAnimatedLeaf(i)
              : _createStaticLeaf(i)
      );
    }
    if (widget.clickable) {
      leaves.add(SizedBox(width: 7,));
      leaves.add(Container(
        // color: Colors.blueAccent,
        child: IconButton(
          icon: Icon(Icons.help, size: helpIconSize,),
          onPressed: () {
            Tools.showAnimatedDialog(context: context,
                title: "Propositions véganes",
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildLeafExplaination(1,
                        "Un strict minimum végan est proposé à la carte."),
                    _buildLeafExplaination(
                        2,
                        "Plusieurs options véganes sont proposées à la carte."),
                    _buildLeafExplaination(3,
                        "La carte est 100% végane ou est entièrement déclinée en version végan."),
                  ],
                ));
          },
          constraints: BoxConstraints(),
          // constraints: BoxConstraints(minHeight: helpIconSize, maxWidth: helpIconSize, minWidth: helpIconSize, maxHeight: helpIconSize),
        ),
      ),);
    }
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: leaves,
    );
  }

  Widget _createAnimatedLeaf(int level) =>
      IconButton(
        icon: ScaleTransition(
          scale: _animControllers[level]!,
          child: Icon(Icons.eco_rounded,
            color: widget.leavesController.leafLevel >= level
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor,
            size: size,
          ),
        ),
        onPressed: () {
          _animate(level);
          widget.leavesController.leafLevel = level;
          setState(() {});
        },
        constraints: BoxConstraints(
            minWidth: size, minHeight: size, maxHeight: size, maxWidth: size),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: padding),
      );


  Widget _createStaticLeaf(int level) =>
      Icon(Icons.eco_rounded,
        color: widget.leavesController.leafLevel >= level
            ? Theme.of(context).primaryColor // Selected
            : Theme.of(context).hintColor,
        size: size, // Not selected
      );

  AnimationController _createAnimationController() =>
      AnimationController(
        duration: const Duration(milliseconds: 125),
        vsync: this,
        value: 1.0,
        lowerBound: 1.0,
        upperBound: 1.75,);

  /// Animates leaves that are equal of of inferior value as the leaf clicked
  /// (represented by its [level]).
  void _animate(int level) {
    _animControllers.forEach((leafLevel, controller) {
      if (leafLevel <= level) {
        controller.forward().then((value) => controller.reverse());
      }
    });
  }

  Widget _buildLeafExplaination(int leafLevel, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Leaves(
                clickable: false,
                leavesController:
                LeavesController(leafLevel: leafLevel)),
          ),
          Text(description),
        ],
      ),
    );
  }
}
