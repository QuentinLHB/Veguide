import 'package:flutter/material.dart';
import 'package:veguide/controller/controller.dart';
import 'package:veguide/view/widgets/leaves_controller.dart';
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
  static const defaultLeavesValue = 1;
  final TextEditingController _cityTextFieldController =
      TextEditingController();
  late FocusNode cityTextFieldFocusNode;
  final Map<Tag, bool> _tagsToggles = {};
  final LeavesController _leafController =
      LeavesController(leafLevel: defaultLeavesValue);

  @override
  void initState() {
    super.initState();
    cityTextFieldFocusNode = FocusNode();
    _resetTagButtons();
  }

  @override
  void dispose() {
    super.dispose();
    _unfocusTextField();
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
              style: Theme.of(context).primaryTextTheme.titleMedium,
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
                            _unfocusTextField();
                          },
                          onEditingComplete: () {
                            _unfocusTextField();
                          },
                        ),
                      ),
                      Leaves(
                          clickable: true, leavesController: _leafController),
                    ],
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    _createTagButton(Tag.cheap),
                    _createTagButton(Tag.rotativeMenu),
                    _createTagButton(Tag.takeAway),
                    _createTagButton(Tag.delivery),
                    _createTagButton(Tag.newPlace),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _createSearchControlButton(Icons.search_rounded, _search),
                    _createSearchControlButton(Icons.delete, _resetFilters),
                  ],
                )
              ],
            ),
            collapsed: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _createSearchSummary(),
            ),
            // collapsed: const SizedBox(height: 20,),
          ),
        ),

        /// Center page
        RestaurantsExpandableList(restaurants: Controller().getRestaurants()),
      ]),
    );
  }

  /// Unfocus the city text field.
  void _unfocusTextField() {
    cityTextFieldFocusNode.unfocus();
  }

  /// Searches the restaurant matching with the criteria.
  void _search() {
    _unfocusTextField();
    // TODO : Search back end goes here.
    setState(() {});
  }

  /// Creates a [TagButton] matching with the [Tag] data passed as argument.
  Widget _createTagButton(Tag tag) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TagButton(
          onPressed: () {
            _unfocusTextField();
            var isToggled = _tagsToggles[tag];
            _tagsToggles[tag] = !isToggled!;
          },
          icon: tag.icon,
          text: tag.name,
          isToggled: _tagsToggles[tag]!,
        ),
      );

  /// Creates a [Wrap] widget containing the city name and the logos
  /// of what the user is searching for (leaves, tags...).
  Widget _createSearchSummary() {
    const padding = 8.0;
    List<Widget> widgets = [];

    // Adds a logo for each active tag button.
    _tagsToggles.forEach((tag, isToggled) {
      if (isToggled) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Icon(
            tag.icon,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ));
      }
    });

    // Adds leaves if they're not the default value.
    if (_leafController.leafLevel != defaultLeavesValue) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Leaves(
            clickable: false,
            leavesController:
                LeavesController(leafLevel: _leafController.leafLevel)),
      ));
    }

    var wrap = Wrap(
      children: widgets,
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
    );

    // Adds the city on top if it has been completed.
    if (_cityTextFieldController.text.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
            child: Text(
              "Ville : " + _cityTextFieldController.text,
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
          ),
          wrap,
        ],
      );
    } else {
      return wrap;
    }
  }

  /// Restores the search widgets to their initial values.
  void _resetFilters() {
    setState(() {
      _cityTextFieldController.text = "";
      _resetTagButtons();
      _leafController.leafLevel = defaultLeavesValue;
    });
    _search();
  }

  /// Restores every [TagButton]s to its initial value.
  void _resetTagButtons() {
    for (Tag tag in Tag.values) {
      _tagsToggles[tag] = false;
    }
  }

  /// Creates a button used for controlling search (i.e. 'search', 'reset' buttons).
  Widget _createSearchControlButton(IconData icon, void Function()? onPressed) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          child: Icon(icon),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
            foregroundColor: MaterialStateProperty.all<Color>(grey)),
      ),
    );

}
