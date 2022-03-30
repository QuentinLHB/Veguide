import 'package:flutter/material.dart';
import 'package:veguide/controller/controller.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/view/styles.dart';
import 'package:veguide/view/widgets/leaves.dart';

class RestaurantsExpandableList extends StatefulWidget {
  RestaurantsExpandableList({Key? key, required this.restaurants})
      : super(key: key);
  List<Restaurant> restaurants;

  @override
  _RestaurantsExpandableListState createState() =>
      _RestaurantsExpandableListState();
}

class _RestaurantsExpandableListState extends State<RestaurantsExpandableList> {
  List<bool> panelOpenList = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i<widget.restaurants.length; i++) {
      panelOpenList.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> panels = [];
    for (var i = 0; i<widget.restaurants.length; i++) {
      panels.add(createRestaurantPanel(i, panelOpenList[i]));
    }

    return ExpansionPanelList(
      children: panels,
      expansionCallback: (index, isOpen){
        setState(() {
          panelOpenList[index] = !isOpen;
        });
      },
    );
  }

  ExpansionPanel createRestaurantPanel(int index, bool open) {
    Restaurant restau = widget.restaurants[index];
    return ExpansionPanel(
        headerBuilder: (context, isOpen) {
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
                          child: restau.imageURI != null
                              ? FadeInImage.assetNetwork(
                                  placeholder:
                                      'assets/images/restau_placeholder.jpg',
                                  image: restau.imageURI!)
                              : Image.asset(
                                  'assets/images/restau_placeholder.jpg'),
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
                            leavesController:
                                LeavesController(leafLevel: restau.leafLevel),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        body: Text("je suis ouvert !!"),
        isExpanded: panelOpenList[index]);
  }
}
