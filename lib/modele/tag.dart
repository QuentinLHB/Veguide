import 'package:flutter/material.dart';
import 'package:veguide/view/widgets/expandable_tag_button.dart';

/// Represents tags that can define a restaurant.
enum Tag{
  cheap,
  rotativeMenu,
  newPlace,
  // glutenFree,
  takeAway,
  delivery,
}

extension TagsText on Tag{
  /// Gets a [Tag]'s name.
  String get name{
    switch(this){
      case Tag.cheap: return "Abordable";
      // case Tags.glutenFree: return "Gluten-free";
      case Tag.newPlace: return "Nouveau";
      case Tag.rotativeMenu: return "Menu rotatif";
      case Tag.takeAway: return "À emporter";
      case Tag.delivery: return "Livraison";


    }
  }
  /// Gets an [IconData] that represents the tag.
  IconData get icon{
    switch(this){
      case Tag.cheap: return Icons.euro_rounded;
      // case Tags.glutenFree: return Icons.people;
      case Tag.newPlace: return Icons.fiber_new_rounded;
      case Tag.rotativeMenu: return Icons.sync;
      case Tag.takeAway: return Icons.shopping_bag_rounded;
      case Tag.delivery: return Icons.motorcycle;
    }
  }

  /// Represent's the text's length
  /// (shitty code used to animate tag buttons, see [ExpandableTagButton] fore more info).
  double get width{
    switch(this){
      case Tag.cheap: return 11;
      case Tag.newPlace: return 13;
      case Tag.rotativeMenu: return 9;
      default: return 10;
    }
  }
}