import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/view/leaves.dart';
import 'package:veguide/view/root.dart';
import 'package:expandable/expandable.dart';

import '../modele/tags.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cityTextFieldController = TextEditingController();
  Map<Tags, bool> _tagsToggles = Map();
  final LeavesController _leafController =
      LeavesController(leafLevel: 3, clickable: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          /// Top menu
          Card(
            child: ExpandablePanel(
              header: Text("Rechercher un restaurant"),
              expanded: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: TextField(
                          controller: cityTextFieldController,
                          decoration: const InputDecoration(
                              hintText: "Lille", labelText: "Ville"),
                          maxLength: 40,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                          onPressed: searchButton_onPressed,
                          icon: Icon(Icons.search_rounded)),
                    ],
                  ),
                  Leaves(leavesController: _leafController),
                  IconButton(
                    icon: Icon(Icons.help),
                    onPressed: () {},
                  ),
                ],
              ),
              collapsed: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Ville :" + cityTextFieldController.text),
              ),
            ),
          ),

          /// Center page
          Flexible(
            flex: 8,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ]),
      ),
    );
  }

  void searchButton_onPressed() {
    // Search for a city
  }
}
