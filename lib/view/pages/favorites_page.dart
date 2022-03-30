import 'package:flutter/material.dart';
import 'package:veguide/controller/controller.dart';
import 'package:veguide/view/widgets/restaurants_expandable_list.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    // return RestaurantsExpandableList(restaurants: Controller().getFavorites());
    return Text("");
  }
}
