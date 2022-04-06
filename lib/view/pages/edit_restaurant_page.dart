import 'package:flutter/material.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/view/widgets/app_title.dart';
import 'package:veguide/view/styles.dart';
import 'package:veguide/view/widgets/suggestion_field.dart';

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

  bool _isSent = false;

  Category? _dropDownValue;

  // @override void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // _dropDownValue = Category.name;
  // }

  @override
  Widget build(BuildContext context) {
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
    Widget field;
    switch (_dropDownValue) {
      case Category.name:
        field = _buildNameCategory();
        break;
      case Category.contact:
        field = _buildContactCategory();
        break;
      case Category.schedule:
        field = _buildScheduleCategory();
        break;
      case Category.leafLevel:
        field = _buildLeafLevelCategory();
        break;
      case Category.tags:
        field = _buildTagsCategory();
        break;
      case Category.other:
        field = _buildOtherCategory();
        break;
      default:
        field = Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          Text(
            "Choisissez l'élément dont vous suggérez la modification",
            style: Theme.of(context).primaryTextTheme.titleMedium,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Catégorie :", style: Theme.of(context).primaryTextTheme.bodyMedium,),
              separator,
              DropdownButton<Category>(
                value: _dropDownValue,
                items: Category.values
                    .map<DropdownMenuItem<Category>>((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (Category? newValue) {
                  setState(() {
                    _dropDownValue = newValue;
                  });
                },
                focusColor: deepGreen,
                underline: Container(height: 2, color: deepGreen),
              ),
            ],
          ),
          separator,
          field,
          _buildAdditionalComment(),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  //TODO : Envoyer
                  setState(() {
                    _isSent = true;
                  });
                },
                child: Text("Envoyer")),
          )
        ],
      ),
    );
  }

  Widget _buildNameCategory() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRichText("Nom actuel", widget.restaurant.name),
          separator,
          SuggestionField(
              text: "Votre proposition",
              hint: widget.restaurant.name,
              controller: TextEditingController()),
        ],
      );

  Widget _buildContactCategory() => Column(
    children: [
      _buildRichText("Numéro actuel", widget.restaurant.phone),
      separator,
      SuggestionField(text: "Correction", hint: "0320010203", controller: TextEditingController()),
      separator,
      widget.restaurant.website != null ? _buildRichText("Site renseigné", widget.restaurant.website!) : Text("Aucun site renseigné"),
      separator,
      SuggestionField(text: "Site du restaurant", hint: "https://www.monsite.fr", controller: TextEditingController()),
      separator,
      widget.restaurant.fb != null ? _buildRichText("Facebook renseigné", widget.restaurant.fb!) : Text("Aucun Facebook renseigné"),
      separator,
      SuggestionField(text: "Facebook du restaurant", hint: "https://www.facebook.com/restaurant", controller: TextEditingController()),

    ],
  );

  Widget _buildScheduleCategory() => Container();

  Widget _buildLeafLevelCategory() => Container();

  Widget _buildTagsCategory() => Container();

  Widget _buildOtherCategory() => Container();

  Widget _buildAdditionalComment() => SuggestionField(
        text: "Commentaire (opt.)",
        hint: "",
        controller: TextEditingController(),
        isMultiLine: true,
        charLimit: 500,
      );

  Widget _buildRichText(String key, String value)=>
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: key + " :",
                style: Theme.of(context).primaryTextTheme.bodyMedium),
            TextSpan(
                text: value,
                style: Theme.of(context).primaryTextTheme.bodyLarge),
          ],
        ),
      );
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
