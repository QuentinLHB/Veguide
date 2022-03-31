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
        phone: "0678549057",
        address: "75 Bd de la Liberté",
        cityCode: "59000",
        city: "Lille",
        imageURI:
            "https://scontent.fcdg1-1.fna.fbcdn.net/v/t1.18169-9/21731345_362591967511569_6909665824263452218_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=WJsRGbalGhMAX90XkBo&_nc_ht=scontent.fcdg1-1.fna&oh=00_AT_fvowCBUn-A84uC_T7T4UkwXQggfXBgfydKZMUPe2iLA&oe=6268502A",
        leafLevel: 2,
        tagIds: [4]);

    var r2 = Restaurant(
        id: 2,
        name: "Annie's Kitchen",
        desc:
            "Des plats français & du monde revisités, à la façon d'un estaminet. Blanquette, carbonade, ramen, poutine, tartare & co n'auront plus de secret pour vous.. & en version 100% végétale !",
        website: "https://www.annieskitchen.fr/",
        fb: "https://www.facebook.com/annieskitchenlille/",
        phone: "06 78 54 90 57",
        address: "222 Rue Léon Gambetta",
        cityCode: "59000",
        city: "Lille",
        imageURI:
            "https://scontent.fcdg1-1.fna.fbcdn.net/v/t1.18169-9/27751512_165608680890200_4058145502370455996_n.jpg?_nc_cat=102&ccb=1-5&_nc_sid=174925&_nc_ohc=Ci8t__dM6H8AX-hfQ7w&_nc_ht=scontent.fcdg1-1.fna&oh=00_AT8XzPU0rIUk8BUQFQODxOme4PyfklrShltqZkovX80K7g&oe=62688694",
        leafLevel: 3,
        tagIds: [5, 4]);

    var r3 = Restaurant(
        id: 3,
        name: "Pause.",
        desc:
        "Plats créatifs à tendance saine, dont des options vegan, pour ce café et restaurant cosy avec mini terrasse.",
        phone: "03 20 40 70 45",
        address: "25 Rue Pierre Mauroy",
        cityCode: "59000",
        city: "Lille",
        imageURI:
        "https://vegoresto.fr/wp-content/uploads/2017/05/restaurant-vegetarien-lille-pause0.png",
         leafLevel: 3,
        tagIds: [1, 2, 3, 4, 5]);

    var r4 = Restaurant(
        id: 3,
        name: "L'atmosphère",
        desc:
        "Nos pizzas sont cuites sur pierre,notre pâte est faite maison chaque jour sans graisse animale,ni huile de palme,ni produits surgelés.",
        phone: "09 81 79 45 89",
        address: "12 Rue Henri Kolb",
        cityCode: "59000",
        city: "Lille",
        imageURI:
        "",
        leafLevel: 3,

        tagIds: [1]);

      var r5 = Restaurant(
        id: 3,
        name: "Happy F'eat",
        desc:
        "Restaurant, salon de thé et bar découverte cosy pour un plat du jour unique, bio, sans gluten et sans lactose.",
          phone: "03 28 14 18 59",
        address: "106 Rue de l'Hôpital Militaire",
        cityCode: "59000",
        city: "Lille",
        imageURI:
        "",
        leafLevel: 2,
      tagIds: [1, 2]);



    return [r1, r2, r3, r4, r5];
  }

  List<Restaurant> getFavorites(){
    return getRestaurants();
  }
}
