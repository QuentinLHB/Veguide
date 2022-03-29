import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/view/widgets/leaves.dart';
import 'package:veguide/view/root.dart';
import 'package:expandable/expandable.dart';
import 'package:veguide/view/widgets/tag_button.dart';
import 'package:veguide/view/styles.dart';

import '../../controller/controller.dart';
import '../../modele/tags.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cityTextFieldController = TextEditingController();
  Map<Tags, bool> _tagsToggles = {};
  final LeavesController _leafController =
      LeavesController(leafLevel: 1, clickable: true);

  List<Restaurant> _restaurants = [];

  @override
  void initState() {
    super.initState();
    for (Tags tag in Tags.values) {
      _tagsToggles[tag] = false;
    }

    Controller controller = Controller();
    _restaurants = controller.getRestaurants();
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
                Row(
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
                            icon: const Icon(Icons.search_rounded)),
                      ],
                    ),
                    Leaves(leavesController: _leafController),
                    IconButton(
                      icon: const Icon(Icons.help),
                      onPressed: () {},
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    createTagButton(Tags.cheap),
                    createTagButton(Tags.rotativeMenu),
                    createTagButton(Tags.cosy),
                    createTagButton(Tags.newPlace),
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
        Scrollbar(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _restaurants.length, //todo change
              itemBuilder: (context, index) {
                Restaurant restau = _restaurants[index];
                return Container(
                  height: 125,
                  child: Card(
                    child: Row(
                      children: [
                        /// Left part containing the image.
                        Flexible(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: PhysicalModel(
                              color: Colors.black,
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(10.0),
                              shadowColor: Colors.green.shade900,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  restau.imageURI ??
                                      "https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Begrippenlijst.svg",
                                  // TODO remplacer par asset
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Right part containing the info.
                        Flexible(
                          flex: 7,
                          child: Align(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  restau.name,
                                  style: styleH2,
                                ),
                                Text(
                                  restau.address,
                                  style: styleH6,
                                ),
                                Text(
                                  restau.cityCode + " " + restau.city,
                                  style: styleH6,
                                ),
                                Leaves(
                                  leavesController: LeavesController(
                                      leafLevel: restau.leafLevel),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }

  void searchButton_onPressed() {
    setState(() {});
  }

  Widget createTagButton(Tags tag) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TagButton(
          onPressed: () {
            var isToggled = _tagsToggles[tag];
            _tagsToggles[tag] = !isToggled!;
          },
          icon: tag.icon,
          text: tag.name,
        ),
      );

  Widget createSummary() {
    const padding = 8.0;
    List<Widget> wrapWidgets = [];
    if (cityTextFieldController.text != "") {
      wrapWidgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Text(
          cityTextFieldController.text,
          style: styleH4,
        ),
      ));
    }
    _tagsToggles.forEach((tag, isToggled) {
      if (isToggled) {
        wrapWidgets.add(Padding(
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
      wrapWidgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Leaves(
            leavesController: LeavesController(
                leafLevel: _leafController.leafLevel, clickable: false)),
      ));
    }

    return Wrap(
      children: wrapWidgets,
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
    );
  }
}
