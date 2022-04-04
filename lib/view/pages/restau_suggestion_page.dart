import 'package:flutter/material.dart';
import 'package:veguide/controller/leaves_controller.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/view/styles.dart';
import 'package:veguide/view/widgets/app_title.dart';
import 'package:veguide/view/widgets/field_widget.dart';
import 'package:veguide/view/widgets/leaves.dart';
import 'package:veguide/view/widgets/tag_button.dart';

class RestaurantSuggestionPage extends StatefulWidget {
  const RestaurantSuggestionPage({Key? key}) : super(key: key);

  @override
  _RestaurantSuggestionPageState createState() =>
      _RestaurantSuggestionPageState();
}

class _RestaurantSuggestionPageState extends State<RestaurantSuggestionPage> {
  TextEditingController textEditingController = TextEditingController();

  LeavesController _leavesController = LeavesController(
      leafLevel: 1, clickable: true);
  final Map<Tag, bool> _tagsToggles = {};

  bool _isSent = false;

  @override void initState() {
    // TODO: implement initState
    super.initState();
    for (Tag tag in Tag.values) {
      _tagsToggles[tag] = false;
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
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FieldWidget(
          text: "Nom",
          controller: textEditingController,
          mandatory: true,
        ),
        FieldWidget(
          text: "Adresse",
          controller: textEditingController,
          mandatory: true,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FieldWidget(
              text: "Code postal",
              controller: textEditingController,
              mandatory: true,
              isNumber: true,
              screenRatio: 7,
              charLimit: 5,
            ),
            FieldWidget(
              text: "Ville",
              controller: textEditingController,
              mandatory: true,
              screenRatio: 3,
              charLimit: 45,
            ),
          ],
        ),
        FieldWidget(text: "Description",
          controller: textEditingController,
          isMultiLine: true,
          charLimit: 250,),
        Row(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("Options véganes :", style: Theme
                .of(context)
                .textTheme
                .titleMedium,),
          ),
          Leaves(leavesController: _leavesController, isLarge: true,),
        ],),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Tags :", style: Theme
              .of(context)
              .textTheme
              .titleMedium,),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [

                createTagButton(Tag.cheap),
                createTagButton(Tag.rotativeMenu),
                createTagButton(Tag.takeAway),
                createTagButton(Tag.delivery),
                createTagButton(Tag.newPlace),
              ],),
          ),
        ),
        FieldWidget(text: "Commentaire",
          controller: textEditingController,
          isMultiLine: true,
          charLimit: 500,),
        Center(
          child: ElevatedButton(child: Text("Envoyer"), onPressed: () {
            setState(() {
              //TODO vérifier les champs.
              _isSent = true;
            });
          },),)
      ],
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
            style: styleH2,),
        ),
        SizedBox(height: 7,),
        Center(
          child: Text(
            "Un email vous sera envoyé dès qu'elle sera traitée.",
            style: styleH4,),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: ElevatedButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Retour à l'application")),
        )
      ],
    );
  }

  Widget createTagButton(Tag tag) =>
      Padding(
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
