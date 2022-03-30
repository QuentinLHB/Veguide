import 'package:flutter/material.dart';

enum Tags{
  cheap,
  rotativeMenu,
  newPlace,
  // glutenFree,
  takeAway,
  delivery,
}

extension TagsText on Tags{
  String get name{
    switch(this){
      case Tags.cheap: return "Abordable";
      // case Tags.glutenFree: return "Gluten-free";
      case Tags.newPlace: return "Nouveau";
      case Tags.rotativeMenu: return "Menu rotatif";
      case Tags.takeAway: return "À emporter";
      case Tags.delivery: return "Livraison";


    }
  }

  IconData get icon{
    switch(this){
      case Tags.cheap: return Icons.euro_rounded;
      // case Tags.glutenFree: return Icons.people;
      case Tags.newPlace: return Icons.fiber_new_rounded;
      case Tags.rotativeMenu: return Icons.sync;
      case Tags.takeAway: return Icons.shopping_bag_rounded;
      case Tags.delivery: return Icons.motorcycle;
    }
  }
}