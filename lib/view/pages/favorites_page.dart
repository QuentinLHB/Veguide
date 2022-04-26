import 'package:flutter/material.dart';
import 'package:veguide/controller/controller.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/view/widgets/restaurants_expandable_list.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  bool _isLoading = false;

  List<Restaurant> _favoriteRestaurants = [];

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Controller().getFavorites().then((favs) {
      setState(() {
        setState(() {
          _favoriteRestaurants = favs;
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isLoading
            ?
            Center(child: CircularProgressIndicator(),)
        :
        RestaurantsExpandableList(restaurants: _favoriteRestaurants),
      ],
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
