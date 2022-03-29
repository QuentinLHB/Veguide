import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';

class Leaves extends StatefulWidget {
  Leaves({Key? key, required this.leavesController}) : super(key: key);

  LeavesController leavesController;

  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text("a"),
        // Text("a"),
        // Text("a"),

        createLeaf(1),
        createLeaf(2),
        createLeaf(3),
      ],
    );
  }

  Widget createLeaf(int level) => IconButton(
        icon: Icon(Icons.eco_rounded,
            color: widget.leavesController.leafLevel >= level
                ? Colors.green[700] // Selected
                : Colors.black.withOpacity(0.5) ,
          size: 30,// Not selected
            ),
        onPressed: widget.leavesController.clickable ? () {
          setState(() {
            widget.leavesController.leafLevel = level;
          });
        }
        : null,
      constraints: BoxConstraints(),
    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2 ),
      );
}
