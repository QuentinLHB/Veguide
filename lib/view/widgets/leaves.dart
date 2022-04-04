import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:flutter/animation.dart';
import 'package:veguide/view/styles.dart';

class Leaves extends StatefulWidget {
  Leaves({Key? key, required this.leavesController, this.isLarge = false}) : super(key: key);

  LeavesController leavesController;
  bool isLarge;

  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> with TickerProviderStateMixin {
  Map<int, AnimationController> _animControllers ={};
  double get size => widget.isLarge ? 40 : 30;
  double get padding => widget.isLarge ? 3 : 1;
  static const helpIconSize = 30.0;

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
    if(widget.leavesController.clickable){
      leaves.add(SizedBox(width: 7,));
      leaves.add(Container(
        // color: Colors.blueAccent,
        child: IconButton(
          icon: Icon(Icons.help, size: helpIconSize,),
          onPressed: () {
            showGeneralDialog(
              context: context,
              transitionBuilder: (context, a1, a2, widget) {
                return Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                    opacity: a1.value,
                    child: _buildPopupDialog(context),
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 200),
              pageBuilder: (context, anim1, anim2) {
                return SizedBox.shrink();
              },
            );
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
                ? deepGreen
                : black,
            size: size,
          ),
        ),
        onPressed: () {
          _animate(level);
          widget.leavesController.leafLevel = level;
          setState(() {});
        },
        constraints: BoxConstraints(minWidth: size, minHeight: size, maxHeight: size, maxWidth: size),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: padding),
      );


  Widget _createStaticLeaf(int level)=>
      Icon(Icons.eco_rounded,
      color: widget.leavesController.leafLevel >= level
          ? deepGreen // Selected
          : black,
      size: size, // Not selected
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

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      title: const Text('Propositions véganes'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildLeafExplaination(1,
              "Un strict minimum végan est proposé à la carte."),
          _buildLeafExplaination(
              2, "Plusieurs options véganes sont proposées à la carte"),
          _buildLeafExplaination(3,
              "La carte est 100% végane ou la décline entièrement en version végan."),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
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
                leavesController:
                LeavesController(leafLevel: leafLevel, clickable: false)),
          ),
          Text(description),
        ],
      ),
    );
  }
}
