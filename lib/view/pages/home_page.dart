import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/view/widgets/leaves.dart';
import 'package:veguide/view/root.dart';
import 'package:expandable/expandable.dart';
import 'package:veguide/view/widgets/restaurants_expandable_list.dart';
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
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextField(
                              controller: cityTextFieldController,
                              decoration: const InputDecoration(
                                hintText: "Lille",
                                labelText: "Ville",
                              ),
                              maxLength: 25,
                              maxLines: 1,
                              onSubmitted: (text) {
                                searchButton_onPressed();
                              },
                            ),
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
                    createTagButton(Tags.takeAway),
                    createTagButton(Tags.delivery),
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
        RestaurantsExpandableList(restaurants: Controller().getRestaurants()),
        // Scrollbar(
        //   child: ListView.builder(
        //       scrollDirection: Axis.vertical,
        //       shrinkWrap: true,
        //       itemCount: _restaurants.length, //todo change
        //       itemBuilder: (context, index) {
        //         Restaurant restau = _restaurants[index];
        //         return ;
        //       }),
        // ),
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

    if (cityTextFieldController.text != "") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
            child: Text(
              "Ville : " + cityTextFieldController.text,
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
}
