import 'package:flutter/material.dart';

enum Tags{
  cheap,
  rotativeMenu,
  newPlace,
  cosy,
}

extension TagsText on Tags{
  String get name{
    switch(this){
      case Tags.cheap: return "Abordable";
      case Tags.cosy: return "Convivial";
      case Tags.newPlace: return "Nouveau";
      case Tags.rotativeMenu: return "Menu rotatif";
    }
  }

  IconData get icon{
    switch(this){
      case Tags.cheap: return Icons.euro_rounded;
      case Tags.cosy: return Icons.people;
      case Tags.newPlace: return Icons.fiber_new_rounded;
      case Tags.rotativeMenu: return Icons.sync;
    }
  }
}