import 'package:flutter/material.dart';
import 'package:veguide/controller/controller.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/view/styles.dart';
import 'package:veguide/view/widgets/expandable_tag_button.dart';
import 'package:veguide/view/widgets/leaves.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantsExpandableList extends StatefulWidget {
  RestaurantsExpandableList({Key? key, required this.restaurants})
      : super(key: key);
  List<Restaurant> restaurants;

  @override
  _RestaurantsExpandableListState createState() =>
      _RestaurantsExpandableListState();
}

class _RestaurantsExpandableListState extends State<RestaurantsExpandableList> {
  List<bool> _panelOpenList = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.restaurants.length; i++) {
      _panelOpenList.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> panels = [];
    for (var i = 0; i < widget.restaurants.length; i++) {
      panels.add(_createRestaurantPanelHeader(i, _panelOpenList[i]));
    }

    return Expanded(
      child: ListView(children: [
        ExpansionPanelList(
          children: panels,
          expansionCallback: (index, isOpen) {
            setState(() {
              _panelOpenList[index] = !isOpen;
            });
          },
        ),
      ]),
    );
  }

  ExpansionPanel _createRestaurantPanelHeader(int index, bool open) {
    Restaurant restau = widget.restaurants[index];
    return ExpansionPanel(
      headerBuilder: (context, isOpen) {
        return SizedBox(
          height: 125,
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
                              imageErrorBuilder: (context, object, trace) {
                                return Image.asset(
                                    'assets/images/restau_placeholder.jpg');
                              },
                              image: restau.imageURI!)
                          : Image.asset('assets/images/restau_placeholder.jpg'),
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
        );
      },
      body: createExpandedBody(widget.restaurants[index]),
      isExpanded: _panelOpenList[index],
      canTapOnHeader: true,
    );
  }

  Widget createExpandedBody(Restaurant restaurant) {
    List<Widget> tagButtons = [];
    for (Tag tag in restaurant.tags) {
      tagButtons.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 5.0),
        child: ExpandableTagButton(tag: tag),
      ));
    }
    
    List<Widget> contactButtons = [];
    contactButtons.add(createContactButton(prefix: "tel:", contactLink: restaurant.phone, icon: Icons.local_phone_rounded, content: restaurant.phone),);
    if(restaurant.website != null){
      contactButtons.add(createContactButton(prefix:"https:", contactLink:restaurant.website!, content: "Site"),);
    }
    if(restaurant.fb != null){
      contactButtons.add(createContactButton(prefix:"https:", contactLink:restaurant.fb!, icon: Icons.facebook_rounded));
    }


    return Column(
      children: [
        Wrap(children :contactButtons),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Text(
            restaurant.desc,
            style: italicGreen,
          ),
        ),
        Wrap(
          children: tagButtons,
        )
      ],
    );
  }


  //TODO: Améliorer : Envoyer onpressed directement plutôt qu'un préfix foireux.
  /// Creates a widget displaying an [icon] or not, a [String] [content] or not. When clicked, it launches
  /// the contact, according to the [prefix] (tel or https).
  Widget createContactButton({IconData? icon, required String prefix, required String contactLink, String? content}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: ElevatedButton(
        onPressed: () {
          if(prefix == "tel:"){
            _makePhoneCall(contactLink);
          }else{
            _launchInBrowser(contactLink);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon == null ? const SizedBox.shrink() : Icon(icon),
            content == null ? const SizedBox.shrink() : Text(content),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(deepGreen),
        ),
      ),
    ),
  );

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
}
