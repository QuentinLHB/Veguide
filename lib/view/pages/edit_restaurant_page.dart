import 'package:flutter/material.dart';
import 'package:veguide/view/widgets/leaves_controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';
import 'package:veguide/view/widgets/app_title.dart';
import 'package:veguide/view/widgets/ask_email.dart';
import 'package:veguide/view/widgets/leaves.dart';
import 'package:veguide/view/widgets/restaurant_image.dart';
import 'package:veguide/view/widgets/suggestion_field.dart';
import 'package:veguide/view/widgets/on_off_button.dart';
import 'package:veguide/view/widgets/thanks_widget.dart';

class EditRestaurantPage extends StatefulWidget {
  EditRestaurantPage({Key? key, required this.restaurant}) : super(key: key);

  Restaurant restaurant;

  @override
  _EditRestaurantPageState createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  /// Cloned version of the restaurant passed in the [EditRestaurantPage] widget.
  late Restaurant _restaurant;

  /// Map storing modifications asked by the user.
  /// * Key stores the info that the user wishes to modify (i.e. 'name').
  /// * Value stores the value of this info (i.e. 'the great vegan restaurant').
  Map<String, String> _modifications = {};

  /// Gets a string of what's in [_modifications] map.
  get _modificationString {
    String modifications = "";
    _modifications.forEach((key, value) {
      modifications += "$key : $value\n";
    });
    return modifications;
  }

  /// [true] when the form has been submitted.
  bool _isSent = false;

  /// Controller of the [Leaves] object.
  late LeavesController _leavesController;

  /// Value of the [AskEmail]'s checkbox. False by default.
  bool _wantsEmail = false;

  /// Schedule String, used in the schedule edition text field.
  String _schedules = "";

  /// Comment [TextField] controller.
  TextEditingController _commentController = TextEditingController();

  /// Email [TextField] controller.
  TextEditingController _emailController = TextEditingController();

  /// Returns the edit icon of size [size] and color [color].
  /// Defaults on a black, size 24 edit note icon.
  Widget _editIcon({double? size = 24, Color? color = Colors.black}) {
    return Icon(Icons.edit_note, color: color, size: ((size ?? 24) + 4));
  }

  @override
  void initState() {
    super.initState();
    _restaurant = widget.restaurant.clone();
    _leavesController =
        LeavesController(leafLevel: _restaurant.leafLevel);
    _schedules = _restaurant.scheduleDisplay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppTitle(),
      ),
      body: _isSent ? ThanksWidget() : _buildForm(),
    );
  }

  /// Builds the form.
  Widget _buildForm() {
    final double padding = 8.0;
    final String popupTitle = "Modification";
    List<Widget> tagButtons = [];
    Tag.values.forEach((tag) {
      tagButtons.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: OnOffButton(
          icon: tag.icon,
          text: tag.name,
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
                    textInputType: TextInputType.phone,
                    hint: _restaurant.phone,
                    maxLength: 10),
                actions: _buildPopUpButtons(updateFunction: () {
                  if (controller.text != "" &&
                      controller.text != _restaurant.phone) {
                    _restaurant.phone = controller.text;
                    _appendModificationString("Phone", _restaurant.phone);
                  }
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
              actions: _buildPopUpButtons(updateFunction: () {
                if (controller.text != "" &&
                    controller.text != _restaurant.website) {
                  _restaurant.website = controller.text;
                  _appendModificationString("Website", _restaurant.website!);
                }
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
              actions: _buildPopUpButtons(updateFunction: () {
                if (controller.text != "" &&
                    controller.text != _restaurant.fb) {
                  _restaurant.fb = controller.text;
                  _appendModificationString("Facebook", _restaurant.fb!);
                }
              }));
        },
        icon: Icons.facebook_rounded,
      ),
    );

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Sélectionnez sur les éléments que vous souhaitez modifier, puis cliquez sur 'Envoyer'.",
            style: Theme.of(context).primaryTextTheme.titleSmall,
          ),
        ),
        Card(
          elevation: 3,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
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
                              Positioned.fill(
                                child: IconButton(
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
                                          actions: _buildPopUpButtons(updateFunction: () {
                                            if (controller.text != "" &&
                                                controller.text !=
                                                    _restaurant.imageURI) {
                                              _restaurant.imageURI =
                                                  controller.text;
                                              _appendModificationString("Image",
                                                  _restaurant.imageURI!);
                                            }
                                          }));
                                    },
                                    icon: _editIcon(
                                        size: 50, color: Colors.white)),
                              ),
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
                          Padding(
                            padding: EdgeInsets.only(bottom: padding),
                            child: InkWell(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _restaurant.name,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleLarge,
                                  ),
                                  _editIcon(
                                      size: Theme.of(context)
                                          .primaryTextTheme
                                          .titleLarge
                                          ?.fontSize,
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .titleLarge
                                          ?.color),
                                ],
                              ),
                              onTap: () {
                                TextEditingController controller =
                                    TextEditingController();
                                Tools.showAnimatedDialog(
                                  context: context,
                                  title: popupTitle,
                                  content: _buildPopUpTextField(
                                      maxLength: 50,
                                      controller: controller,
                                      hint: _restaurant.name),
                                  actions: _buildPopUpButtons(updateFunction: () {
                                      if (controller.text != "" &&
                                          controller.text != _restaurant.name) {
                                        _restaurant.name = controller.text;
                                        _appendModificationString(
                                            "Nom", _restaurant.name);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),

                          /// Restaurant's address.
                          Padding(
                            padding: EdgeInsets.only(bottom: padding),
                            child: InkWell(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _restaurant.address,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium,
                                  ),
                                  _editIcon(
                                      size: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium
                                          ?.fontSize,
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium
                                          ?.color),
                                ],
                              ),
                              onTap: () {
                                TextEditingController controller =
                                    TextEditingController();
                                Tools.showAnimatedDialog(
                                  context: context,
                                  title: popupTitle,
                                  content: _buildPopUpTextField(
                                      maxLength: 200,
                                      controller: controller,
                                      hint: _restaurant.address),
                                  actions: _buildPopUpButtons(updateFunction: () {
                                      if (controller.text != "" &&
                                          controller.text !=
                                              _restaurant.address) {
                                        _restaurant.address = controller.text;
                                        _appendModificationString(
                                            "Address", _restaurant.address);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: padding),
                            child: InkWell(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_restaurant.cityCode + " ",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium),
                                  Text(_restaurant.city,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium),
                                  _editIcon(
                                      size: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium
                                          ?.fontSize,
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium
                                          ?.color),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Text("Code postal :"),
                                          ),
                                          Expanded(
                                            child: _buildPopUpTextField(
                                                controller: cityCodeController,
                                                hint: _restaurant.cityCode,
                                                textInputType: TextInputType.number,
                                                maxLength: 5),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Text("Ville :"),
                                          ),
                                          Expanded(
                                            child: _buildPopUpTextField(
                                                maxLength: 45,
                                                controller: cityController,
                                                hint: _restaurant.city),
                                          ),
                                        ],
                                      ),
                                      // Text("tets"),
                                    ],
                                  ),
                                  actions: _buildPopUpButtons(updateFunction: () {
                                      if (cityCodeController.text != "" &&
                                          cityCodeController.text !=
                                              _restaurant.cityCode) {
                                        _restaurant.cityCode =
                                            cityCodeController.text;
                                        _appendModificationString("Code postal",
                                            _restaurant.cityCode);
                                      }
                                      if (cityController.text != "" &&
                                          cityController.text !=
                                              _restaurant.address) {
                                        _restaurant.city = cityController.text;
                                        _appendModificationString(
                                            "Ville", _restaurant.city);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),

                          Leaves(clickable: true, leavesController: _leavesController),
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
                          color: Theme.of(context).primaryColor,
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
                      TextEditingController controller =
                          TextEditingController();
                      controller.text = _schedules;
                      List<Widget> popUpButtons = _buildPopUpButtons(updateFunction: () {
                          if (controller.text != _schedules) {
                            _schedules = controller.text;
                            _appendModificationString(
                                "Schedule", controller.text);
                          }
                        },
                      );
                      popUpButtons.insert(
                          0,
                          IconButton(
                              onPressed: () {
                                controller.text = "";
                              },
                              icon: Icon(
                                Icons.delete,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              )));
                      Tools.showAnimatedDialog(
                        context: context,
                        title: popupTitle,
                        content: _buildPopUpTextField(
                            controller: controller,
                            hint: "",
                            maxLines: 8,
                            maxLength: 500,
                            textInputType: TextInputType.multiline),
                        actions: popUpButtons,
                      );
                    },
                  ),
                ),

                Wrap(children: contactButtons),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      child: Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _restaurant.desc,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .labelSmall,
                                ),
                              ),
                            ),
                            _editIcon(color: Theme.of(context).primaryColor)
                          ],
                        ),
                      ),
                      onTap: () {
                        TextEditingController controller =
                            TextEditingController();
                        Tools.showAnimatedDialog(
                            context: context,
                            title: popupTitle,
                            content: _buildPopUpTextField(
                                controller: controller,
                                hint: _restaurant.desc,
                                maxLength: 500,
                                maxLines: 5,
                                textInputType: TextInputType.multiline),
                            actions: _buildPopUpButtons(updateFunction: () {
                              if (controller.text != "" &&
                                  controller.text != _restaurant.desc) {
                                _restaurant.desc = controller.text;
                                _appendModificationString(
                                    "Description", _restaurant.desc);
                              }
                            }));
                      },
                    ),
                  ),
                ),
                Wrap(
                  children: tagButtons,
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SuggestionField(
            text: "Commentaire (optionnel)",
            hint:
                "Commentaire à l'intention de l'administrateur de l'application",
            controller: _commentController,
            isMultiLine: true,
            charLimit: 500,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10.0),
          child: AskEmail(
            onTap: () {
              setState(() {
                _wantsEmail = !_wantsEmail;
              });
            },
            emailFieldController: _emailController,
          ),
        ),

        /// Send button
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
              onPressed:
                  /// Gets the info that changed during the user's edition and sends
              /// them.
                  () {
                for (Tag tag in Tag.values) {
                  if (widget.restaurant.isTagToggled(tag) &&
                      !_restaurant.isTagToggled(tag)) {
                    _appendModificationString("Tag removed", tag.name);
                  } else if (_restaurant.isTagToggled(tag) &&
                      !widget.restaurant.isTagToggled(tag)) {
                    _appendModificationString("Tag added", tag.name);
                  }
                }

                if (_leavesController.leafLevel !=
                    widget.restaurant.leafLevel) {
                  _appendModificationString(
                      "Leaf level", _leavesController.leafLevel.toString());
                }

                if (_commentController.text.isNotEmpty) {
                  _appendModificationString("Comment", _commentController.text);
                }

                if (_modifications.isNotEmpty) {
                  if(_wantsEmail && _emailController.text.isEmpty){
                    showErrorDialog("Envoi impossible", "Veuillez renseigner votre adresse mail.");
                    return;
                  }

                  print(_modificationString);
                  // TODO back end goes here.
                  setState(() {
                    _isSent = true;
                  });
                } else {
                  showErrorDialog("Envoi impossible", "Aucun changement n'a été enregistré.");
                }
              },
              child: Text("Envoyer")),
        ),
      ],
    );
  }

  void showErrorDialog(String title, String text){
    Tools.showAnimatedDialog(
        context: context,
        title: title,
        content: Text(text),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text('OK'),
          ),
        ]);
  }


  /// Creates a button for contact methods (i.e. phone, facebook...).
  /// Event method [onPressed] is required.
  /// The button can be filled by an [icon], and/or text [content].
  /// (Should be one of both to avoid an empty button).
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

  /// Builds a [TextField] used in a pop up menu.
  /// [textInputType] is the input type, typically text, number, or multiline.
  /// [hint] is displayed in the [TextField]
  /// [maxLength] and [maxLines] are optional, and default respectively at 100 chars and 1 line.
  Widget _buildPopUpTextField({
    required TextEditingController controller,
    TextInputType textInputType = TextInputType.text,
    required String hint,
    int maxLength = 100,
    int maxLines = 1,
  }) =>
      TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: textInputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14),
        ),
      );

  /// Builds an OK and a Cancel button, to be displayed in a pop up menu.
  /// The OK button calls the [updateFunction] before closing.
  List<Widget> _buildPopUpButtons({required VoidCallback updateFunction}) => <Widget>[
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

  /// Adds an item to the modification map.
 /// * Key stores the info that the user wishes to modify (i.e. 'name').
/// * Value stores the value of this info (i.e. 'the great vegan restaurant').
  void _appendModificationString(String key, String value) {
    _modifications[key] = value;
  }

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
