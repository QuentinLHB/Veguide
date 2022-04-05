import 'package:flutter/material.dart';
import 'package:veguide/controller/controller.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/modele/schedule.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';
import 'package:veguide/view/styles.dart';
import 'package:veguide/view/widgets/expandable_tag_button.dart';
import 'package:veguide/view/widgets/fav_button.dart';
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

  // final ScrollController _scrollController = ScrollController();

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
      child: ListView(
          // controller: _scrollController,
          children: [
            ExpansionPanelList(
              // expandedHeaderPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              elevation: 2,
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

                  /// Shadow box beneath the image.
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(3, 4), // changes position of shadow
                        ),
                      ],
                    ),

                    /// Restaurant's image.
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: restau.imageURI != null &&
                                  restau.imageURI!.isNotEmpty
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/icons/icon.jpg',
                                  imageErrorBuilder: (context, object, trace) {
                                    return Image.asset('assets/icons/icon.jpg');
                                  },
                                  image: restau.imageURI!)
                              : Image.asset('assets/icons/icon.jpg'),
                        ),
                      ],
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

    contactButtons.add(
      createContactButton(
          onPressed: () => _makePhoneCall(restaurant.phone),
          icon: Icons.local_phone_rounded,
          content: restaurant.phone),
    );
    if (restaurant.website != null) {
      contactButtons.add(createContactButton(
        onPressed: () => _launchInBrowser(restaurant.website!),
        icon: Icons.language_rounded,
      ));
    }
    if (restaurant.fb != null) {
      contactButtons.add(createContactButton(
          onPressed: () => _launchInBrowser(restaurant.fb!),
          icon: Icons.facebook_rounded));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: InkWell(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  color: deepGreen,
                  size: 28,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Heures d'ouverture",
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
              ],
            ),
            onTap: () {
              _openHoursPopUpMenu(restaurant);
            },
          ),
        ),
        Wrap(children: contactButtons),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Text(
            restaurant.desc,
            style: italicGreen,
          ),
        ),
        Wrap(
          children: tagButtons,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.edit_note,
                      // color: deepGreen,
                      size: 20,
                    ),
                    Text(
                      "Suggérer une modification",
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                  ],
                ),
                onTap: () {
                  // TODO : Redirection vers formulaire
                },
              ),
              Spacer(),
              FavButton(
                isFav: restaurant.isFav,
                onPressed: () {
                  restaurant.isFav = !restaurant.isFav;
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  /// Creates a widget displaying an [icon] and/or a [String] [content].
  Widget createContactButton({
    required VoidCallback onPressed,
    String? content,
    IconData? icon,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon == null ? const SizedBox.shrink() : Icon(icon),
                (icon == null || content == null) ? SizedBox.shrink() : SizedBox(width: 4,),
                content == null ? const SizedBox.shrink() : Text(content),
              ],
            ),
            style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
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

  void _openHoursPopUpMenu(Restaurant restaurant) {
    List<Widget> scheduleWidgets = [];
    for (Schedule schedule in restaurant.schedules) {
      scheduleWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: schedule.jour + " : ",
                    style: Theme.of(context).primaryTextTheme.bodyLarge),
                TextSpan(text: schedule.getHours(), style: Theme.of(context).primaryTextTheme.bodyMedium),
              ],
            ),
          ),
        ),
      );
    }

    Tools.showAnimatedDialog(
      context: context,
      title: "Horaires d'ouverture",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: scheduleWidgets,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

// void _scrollDown() {
//   _scrollController.animateTo(
//     _scrollController.position.maxScrollExtent,
//     duration: Duration(seconds: 1),
//     curve: Curves.fastOutSlowIn,
//   );
// }
}
