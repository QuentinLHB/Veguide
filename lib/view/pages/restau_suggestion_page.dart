import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';
import 'package:veguide/view/styles.dart';
import 'package:veguide/view/widgets/app_title.dart';
import 'package:veguide/view/widgets/leaves.dart';
import 'package:veguide/view/widgets/suggestion_field.dart';
import 'package:veguide/view/widgets/tag_button.dart';

class RestaurantSuggestionPage extends StatefulWidget {
  const RestaurantSuggestionPage({Key? key}) : super(key: key);

  @override
  _RestaurantSuggestionPageState createState() =>
      _RestaurantSuggestionPageState();
}

class _RestaurantSuggestionPageState extends State<RestaurantSuggestionPage> {
  Map<Field, TextEditingController> _fieldControllers = {};

  LeavesController _leavesController =
      LeavesController(leafLevel: 1, clickable: true);
  final Map<Tag, bool> _tagsToggles = {};

  bool _isSent = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (Tag tag in Tag.values) {
      _tagsToggles[tag] = false;
    }
    for (Field field in Field.values) {
      _fieldControllers[field] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTitle(),
      ),
      body: _isSent ? _buildThanks() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vous connaissez un restaurant non-répertorié sur l'application ? Proposez-le !",
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
                SizedBox(height: 5,),
                Text(
                  "(*: Champs obligatoires)",
                  style: TextStyle(color: Colors.red.shade700, fontSize: 10),
                ),
              ],
            ),
          ),
          SuggestionField(
            text: "Nom",
            hint: "Mon Restaurant Vegan",
            controller: _fieldControllers[Field.name]!,
            mandatory: true,
          ),
          SuggestionField(
            text: "Adresse",
            hint: "214 rue des animaux",
            controller: _fieldControllers[Field.address]!,
            mandatory: true,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SuggestionField(
                text: "Code postal",
                hint: "59000",
                controller: _fieldControllers[Field.postalCode]!,
                mandatory: true,
                isNumber: true,
                screenRatio: 7,
                charLimit: 5,
              ),
              SuggestionField(
                text: "Ville",
                hint: "Lille",
                controller: _fieldControllers[Field.city]!,
                mandatory: true,
                screenRatio: 3,
                charLimit: 45,
              ),
            ],
          ),
          SuggestionField(
            text: "Description",
            hint:
                "Carte créative proposant des plats 100% végans et de saison, dans une ambiance chaleureuse.",
            controller: _fieldControllers[Field.desc]!,
            isMultiLine: true,
            charLimit: 250,
          ),
          SuggestionField(
            text: "Téléphone",
            hint: "0320010203",
            controller: _fieldControllers[Field.phone]!,
            charLimit: 10,
          ),
          SuggestionField(
            text: "Site",
            hint: "https://www.monrestaurantvegan.fr",
            controller: _fieldControllers[Field.website]!,
            charLimit: 250,
          ),
          Row(
            children: [
              Text(
                "Options véganes :",
                style: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
              Leaves(
                leavesController: _leavesController,
                isLarge: true,
              ),
            ],
          ),
          Text(
            "Tags :",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                createTagButton(Tag.cheap),
                createTagButton(Tag.rotativeMenu),
                createTagButton(Tag.takeAway),
                createTagButton(Tag.delivery),
                createTagButton(Tag.newPlace),
              ],
            ),
          ),
          SuggestionField(
            text: "Commentaire",
            hint:
                "Commentaire à l'intention de l'administrateur de l'application.",
            controller: _fieldControllers[Field.comment]!,
            isMultiLine: true,
            charLimit: 500,
          ),
          SuggestionField(
            text: "Votre email",
            hint: "utilisateur@gmail.com",
            controller: _fieldControllers[Field.email]!,
            mandatory: true,
            charLimit: 50,
          ),
          Center(
            child: ElevatedButton(
              child: Text("Envoyer"),
              onPressed: () {
                if (_fieldControllers[Field.name]!.text.isEmpty ||
                    _fieldControllers[Field.address]!.text.isEmpty ||
                    _fieldControllers[Field.postalCode]!.text.isEmpty ||
                    _fieldControllers[Field.city]!.text.isEmpty ||
                    _fieldControllers[Field.email]!.text.isEmpty) {
                  Tools.showAnimatedDialog(
                      context: context,
                      title: "Champs incomplets",
                      content: Text(
                          "Merci de renseigner tous les champs obligatoires (*)"),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ]);
                } else {
                  // TODO : Insérer le back envoyant un email ici.
                  setState(() {
                    _isSent = true;
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildThanks() {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Merci pour votre suggestion !",
            style: styleH2,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Center(
          child: Text(
            "Un email vous sera envoyé dès qu'elle sera traitée.",
            style: styleH4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Retour à l'application")),
        )
      ],
    );
  }

  Widget createTagButton(Tag tag) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TagButton(
          onPressed: () {
            var isToggled = _tagsToggles[tag];
            _tagsToggles[tag] = !isToggled!;
          },
          icon: tag.icon,
          text: tag.name,
          isToggled: _tagsToggles[tag]!,
        ),
      );
}

enum Field {
  name,
  address,
  city,
  postalCode,
  desc,
  phone,
  website,
  fb,
  comment,
  email,
}
