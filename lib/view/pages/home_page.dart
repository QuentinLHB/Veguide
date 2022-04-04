import 'package:flutter/material.dart';
import 'package:veguide/controller/controller.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/view/widgets/leaves.dart';
import 'package:expandable/expandable.dart';
import 'package:veguide/view/widgets/restaurants_expandable_list.dart';
import 'package:veguide/view/widgets/tag_button.dart';
import 'package:veguide/view/styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityTextFieldController =
      TextEditingController();
  late FocusNode cityTextFieldFocusNode;
  final Map<Tag, bool> _tagsToggles = {};
  final LeavesController _leafController =
      LeavesController(leafLevel: 1, clickable: true);

  @override
  void initState() {
    super.initState();
    cityTextFieldFocusNode = FocusNode();
    _resetTagButtons();
  }

  @override
  void dispose() {
    super.dispose();
    unfocusTextField();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        /// Top menu
        Card(
          child: ExpandablePanel(
            header: Center(
                child: Text(
              "Rechercher un restaurant",
              style: styleH3,
            )),
            expanded: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          controller: _cityTextFieldController,
                          focusNode: cityTextFieldFocusNode,
                          decoration: const InputDecoration(
                            hintText: "Lille",
                            labelText: "Ville / Code Postal",
                          ),
                          maxLength: 25,
                          maxLines: 1,
                          onSubmitted: (text) {
                            // search();
                            unfocusTextField();
                          },
                          onEditingComplete: () {
                            unfocusTextField();
                          },
                        ),
                      ),
                      Leaves(leavesController: _leafController),
                    ],
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    createTagButton(Tag.cheap),
                    createTagButton(Tag.rotativeMenu),
                    createTagButton(Tag.takeAway),
                    createTagButton(Tag.delivery),
                    createTagButton(Tag.newPlace),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: search,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 3.0),
                          child: Icon(Icons.search_rounded),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(deepGreen),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(grey)),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: resetFilters,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 3.0),
                          child: Icon(Icons.delete),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(grey),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(deepGreen)),
                      ),
                    ),
                    //
                    // IconButton(
                    //     onPressed: searchButton_onPressed,
                    //     icon: const Icon(Icons.search_rounded)),
                    // IconButton(
                    //     onPressed: searchButton_onPressed,
                    //     icon: const Icon(Icons.delete)),
                  ],
                )
              ],
            ),
            collapsed: Padding(
              padding: const EdgeInsets.all(10.0),
              child: createSummary(),
            ),
            // collapsed: const SizedBox(height: 20,),
          ),
        ),

        /// Center page
        RestaurantsExpandableList(restaurants: Controller().getRestaurants()),
      ]),
    );
  }

  void unfocusTextField() {
    cityTextFieldFocusNode.unfocus();
  }

  void search() {
    unfocusTextField();
    setState(() {});
  }

  Widget createTagButton(Tag tag) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TagButton(
          onPressed: () {
            unfocusTextField();
            var isToggled = _tagsToggles[tag];
            _tagsToggles[tag] = !isToggled!;
          },
          icon: tag.icon,
          text: tag.name,
          isToggled: _tagsToggles[tag]!,
        ),
      );

  Widget createSummary() {
    const padding = 8.0;
    List<Widget> widgets = [];
    _tagsToggles.forEach((tag, isToggled) {
      if (isToggled) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Icon(
            tag.icon,
            size: 30,
            color: deepGreen,
          ),
        ));
      }
    });

    if (_leafController.leafLevel > 1) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Leaves(
            leavesController: LeavesController(
                leafLevel: _leafController.leafLevel, clickable: false)),
      ));
    }

    var wrap = Wrap(
      children: widgets,
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
    );

    if (_cityTextFieldController.text != "") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
            child: Text(
              "Ville : " + _cityTextFieldController.text,
              style: styleH4,
            ),
          ),
          wrap,
        ],
      );
    } else {
      return wrap;
    }
  }

  void resetFilters() {
    setState(() {
      _cityTextFieldController.text = "";
      _resetTagButtons();
      _leafController.leafLevel = 1;
    });
    search();
  }

  void _resetTagButtons() {
    for (Tag tag in Tag.values) {
      _tagsToggles[tag] = false;
    }
  }
}
