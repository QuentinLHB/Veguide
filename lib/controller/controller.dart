import 'package:veguide/modele/restaurant.dart';

class Controller {
  static final Controller _controller = Controller._privateConstructor();

  /// Private unique instance of the controller.
  Controller._privateConstructor();

  /// Gets the single instance of the controller.
  factory Controller() {
    return _controller;
  }

  List<Restaurant> getRestaurants() {
    //TODO: Test method !
    var r1 = Restaurant(
        id: 1,
        name: "La Clairière",
        desc:
            "Cuisine saine et gourmande privilégiant les aliments BIO et locaux. Garantie sans huile de palme et sans produit d'origine animale.",
        fb: "https://www.facebook.com/LaClairiereLille/",
        phone: "03 20 11 23 16",
        address: "75 Bd de la Liberté",
        cityCode: "59000",
        city: "Lille",
        imageURI:
            "https://scontent.fcdg1-1.fna.fbcdn.net/v/t1.18169-9/21731345_362591967511569_6909665824263452218_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=WJsRGbalGhMAX90XkBo&_nc_ht=scontent.fcdg1-1.fna&oh=00_AT_fvowCBUn-A84uC_T7T4UkwXQggfXBgfydKZMUPe2iLA&oe=6268502A",
        leafLevel: 2);

    var r2 = Restaurant(
        id: 2,
        name: "Annie's Kitchen",
        desc:
            "Des plats français & du monde revisités, à la façon d'un estaminet. Blanquette, carbonade, ramen, poutine, tartare & co n'auront plus de secret pour vous.. & en version 100% végétale !",
        website: "https://www.annieskitchen.fr/",
        fb: "https://www.facebook.com/annieskitchenlille/",
        phone: "03 20 37 32 88",
        address: "222 Rue Léon Gambetta",
        cityCode: "59000",
        city: "Lille",
        imageURI:
            "https://scontent.fcdg1-1.fna.fbcdn.net/v/t1.18169-9/27751512_165608680890200_4058145502370455996_n.jpg?_nc_cat=102&ccb=1-5&_nc_sid=174925&_nc_ohc=Ci8t__dM6H8AX-hfQ7w&_nc_ht=scontent.fcdg1-1.fna&oh=00_AT8XzPU0rIUk8BUQFQODxOme4PyfklrShltqZkovX80K7g&oe=62688694",
        leafLevel: 3);

    return [r1, r2];
  }
}
