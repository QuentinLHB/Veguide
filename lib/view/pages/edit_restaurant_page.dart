import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/modele/schedule.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';
import 'package:veguide/view/widgets/app_title.dart';
import 'package:veguide/view/styles.dart';
import 'package:veguide/view/widgets/leaves.dart';
import 'package:veguide/view/widgets/restaurant_image.dart';
import 'package:veguide/view/widgets/suggestion_field.dart';
import 'package:veguide/view/widgets/tag_button.dart';
import 'package:collection/collection.dart';

class EditRestaurantPage extends StatefulWidget {
  EditRestaurantPage({Key? key, required this.restaurant}) : super(key: key);

  Restaurant restaurant;

  @override
  _EditRestaurantPageState createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  static const SizedBox separator = const SizedBox(
    height: 10.0,
  );

  late Restaurant _restaurant;

  String modificationString = "";

  bool _isSent = false;

  Category? _dropDownValue;
  List<Schedule> schedules = [];

  late LeavesController _leavesController;

  // static const Icon editIcon = Icon(Icons.edit_note);

  Widget editIcon({double? size = 24, Color? color = Colors.black}){
    return Icon(Icons.edit_note, color: color, size: size);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _restaurant = widget.restaurant.clone();
    _leavesController =
        LeavesController(clickable: true, leafLevel: _restaurant.leafLevel);
  }

  @override
  Widget build(BuildContext context) {
    print("building");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppTitle(),
      ),
      body: _isSent ? _buildThanks() : _buildForm(),
    );
  }

  Widget _buildThanks() {
    return Container();
  }

  Widget _buildForm() {
    final String popupTitle = "Modification";
    List<Widget> tagButtons = [];
    Tag.values.forEach((tag) {
      tagButtons.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TagButton(
          onPressed: () {
            if (_restaurant.isTagToggled(tag)) {
              _restaurant.removeTag(tag);
            } else {
              _restaurant.addTag(tag);
            }
            setState(() {});
          },
          isToggled: _restaurant.isTagToggled(tag),
        ),
      ));
    });

    List<Widget> contactButtons = [];

    contactButtons.add(
      createContactButton(
          // Phone button
          onPressed: () {
            TextEditingController controller = TextEditingController();
            Tools.showAnimatedDialog(
                context: context,
                title: popupTitle,
                content: _buildPopUpTextField(
                    controller: controller,
                    inputType: TextInputType.phone,
                    hint: _restaurant.phone,
                    maxLength: 10),
                actions: _buildPopUpButtons(() {
                  _restaurant.phone = controller.text;
                }));
          },
          icon: Icons.local_phone_rounded,
          content: _restaurant.phone),
    );

    contactButtons.add(
      createContactButton(
        // Website button
        onPressed: () {
          TextEditingController controller = TextEditingController();
          Tools.showAnimatedDialog(
              context: context,
              title: popupTitle,
              content: _buildPopUpTextField(
                  controller: controller,
                  hint: _restaurant.website ?? "Aucun site web renseigné"),
              actions: _buildPopUpButtons(() {
                _restaurant.website = controller.text;
              }));
        },
        icon: Icons.language_rounded,
      ),
    );

    contactButtons.add(
      createContactButton(
        // Facebook button
        onPressed: () {
          TextEditingController controller = TextEditingController();
          Tools.showAnimatedDialog(
              context: context,
              title: popupTitle,
              content: _buildPopUpTextField(
                  controller: controller,
                  hint: _restaurant.fb ?? "Aucune page Facebook renseignée"),
              actions: _buildPopUpButtons(() {
                _restaurant.fb = controller.text;
              }));
        },
        icon: Icons.facebook_rounded,
      ),
    );

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            RestaurantImage(
                              imageURI: _restaurant.imageURI,
                            ),
                            IconButton(
                                onPressed: () {
                                  TextEditingController controller =
                                      TextEditingController();
                                  Tools.showAnimatedDialog(
                                      context: context,
                                      title: popupTitle,
                                      content: _buildPopUpTextField(
                                          controller: controller,
                                          hint: _restaurant.imageURI ??
                                              "Renseignez l'URL d'une image."),
                                      actions: _buildPopUpButtons(() {
                                        _restaurant.imageURI = controller.text;
                                      }));
                                },
                                icon: editIcon(size: 50, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Restaurant's name
                        InkWell(
                          child: Row(
                    mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_restaurant.name, style: Theme.of(context).primaryTextTheme.titleLarge,),
                              editIcon(size: Theme.of(context).primaryTextTheme.titleLarge?.fontSize),
                            ],
                          ),
                          onTap: () {
                            TextEditingController controller =
                                TextEditingController();
                            Tools.showAnimatedDialog(
                              context: context,
                              title: popupTitle,
                              content: _buildPopUpTextField(
                                  controller: controller,
                                  hint: _restaurant.name),
                              actions: _buildPopUpButtons(
                                () {
                                  _restaurant.name = controller.text;
                                },
                              ),
                            );
                          },
                        ),

                        /// Restaurant's address.
                        InkWell(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_restaurant.address, style: Theme.of(context).primaryTextTheme.bodyMedium,),
                              editIcon(size: Theme.of(context).primaryTextTheme.bodyMedium?.fontSize, color: Theme.of(context).primaryTextTheme.bodyMedium?.color),
                            ],
                          ),
                          onTap: () {
                            TextEditingController controller =
                                TextEditingController();
                            Tools.showAnimatedDialog(
                              context: context,
                              title: popupTitle,
                              content: _buildPopUpTextField(
                                  controller: controller,
                                  hint: _restaurant.address),
                              actions: _buildPopUpButtons(
                                () {
                                  _restaurant.address = controller.text;
                                },
                              ),
                            );
                          },
                        ),

                        InkWell(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_restaurant.cityCode + " ", style: Theme.of(context).primaryTextTheme.bodyMedium),
                              Text(_restaurant.city, style: Theme.of(context).primaryTextTheme.bodyMedium),
                              editIcon(size: Theme.of(context).primaryTextTheme.bodyMedium?.fontSize, color: Theme.of(context).primaryTextTheme.bodyMedium?.color),
                            ],
                          ),
                          onTap: () {
                            TextEditingController cityCodeController =
                                TextEditingController();
                            TextEditingController cityController =
                                TextEditingController();

                            Tools.showAnimatedDialog(
                              context: context,
                              title: popupTitle,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Code postal :"),
                                      Expanded(
                                        child: _buildPopUpTextField(
                                            controller: cityCodeController,
                                            hint: _restaurant.cityCode,
                                        inputType: TextInputType.number,
                                        maxLength: 5),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Ville :"),
                                      Expanded(
                                        child: _buildPopUpTextField(
                                            controller: cityController,
                                            hint: _restaurant.city),
                                      ),
                                    ],
                                  ),
                                // Text("tets"),
                                ],
                              ),
                              actions: _buildPopUpButtons(
                                () {
                                  _restaurant.cityCode =
                                      cityCodeController.text;
                                  _restaurant.city = cityController.text;
                                },
                              ),
                            );
                          },
                        ),

                        Leaves(leavesController: _leavesController),
                      ],
                    ),
                  ),
                ],
              ),

              /// Horaires
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    //todo horaires ici
                    // TextEditingController controller = TextEditingController();
                    // Tools.showAnimatedDialog(context: context, title: popupTitle, content:
                    // _buildPopUpTextField(controller:controller, hint: _restaurant.address),
                    //   actions: _buildPopUpButtons(() {
                    //     _restaurant.address = controller.text;
                    //   },),);
                  },
                ),
              ),

              Wrap(children: contactButtons),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: Text(
                  _restaurant.desc,
                  style: italicGreen,
                ),
              ),
              Wrap(
                children: tagButtons,
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                (icon == null || content == null)
                    ? SizedBox.shrink()
                    : SizedBox(
                        width: 4,
                      ),
                content == null ? const SizedBox.shrink() : Text(content),
              ],
            ),
            style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                ),
          ),
        ),
      );

  Widget _buildPopUpTextField(
          {required TextEditingController controller,
          TextInputType inputType = TextInputType.text,
          required String hint,
          int maxLength = 100}) =>
      TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: inputType,
        maxLines: 1,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14)),
      );

  List<Widget> _buildPopUpButtons(VoidCallback updateFunction) => <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            updateFunction();
            Navigator.of(context).pop();
            setState(() {});
          },
          child: const Text('OK'),
        ),
      ];

// Future<TimeOfDay?> _selectTime(BuildContext context, TimeOfDay? initialTime) async {
//   final TimeOfDay? selectedTimeOfDay = await showTimePicker(
//     context: context,
//     initialTime: widget.restaurant.schedules[0].closesAtAM ?? TimeOfDay.now(),
//     initialEntryMode: TimePickerEntryMode.dial,
//   );
//   if(selectedTimeOfDay != null)
//   {
//     return selectedTimeOfDay;
//   }
//   return initialTime;
// }
}

enum Category {
  name,
  contact,
  schedule,
  leafLevel,
  tags,
  other,
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.name:
        return "Nom";
      case Category.contact:
        return "Coordonnées";
      case Category.schedule:
        return "Horaires";
      case Category.leafLevel:
        return "Propositions véganes";
      case Category.tags:
        return "Tags";
      case Category.other:
        return "Autre";
      default:
        return "";
    }
  }
}
