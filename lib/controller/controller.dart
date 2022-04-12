import 'package:flutter/material.dart';
import 'package:veguide/modele/distant_access.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/modele/schedule.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';

class Controller {
  static final Controller _controller = Controller._privateConstructor();
  late DistantAccess _distantAccess;

  /// Private unique instance of the controller.
  Controller._privateConstructor() {
    _distantAccess = DistantAccess();
  }

  /// Gets the single instance of the controller.
  factory Controller() {
    return _controller;
  }

  /// Returns the list of [Restaurant] searched by the user.
  Future<List<Restaurant>> getRestaurants({
    String? city,
    int? leafLevel,
    List<Tag>? tags,
    int distanceKm: 15,
  }) async {
    List<Restaurant> restaurants = [];
    if(city == null || city.isEmpty){
      city = "Lille";
    }

    String query = '''SELECT 
        r.id as 'idRestau',
    r.NAME as 'restauName',
    r.DESCRIPTION,
    r.IMG,
    r.ADDRESS,
    c.POSTAL_CODE,
    c.NAME as 'cityName',
    r.UPVOTES,
    r.WEBSITE,
    r.LEAFLEVEL,
    r.phone,
    t.ID,
    0 as 'distance'
FROM restaurant r JOIN city c USING (id) LEFT JOIN restaurant_tag rt ON (rt.ID_RESTAURANT = r.ID) LEFT JOIN tag t ON (rt.ID_TAG = t.ID) 
WHERE 
	c.NAME = ? 
UNION
select * from(
	SELECT 
	r.id as 'idRestau',
    r.NAME as 'restauName',
    r.DESCRIPTION,
    r.IMG,
    r.ADDRESS,
    c.POSTAL_CODE,
    c.NAME as 'cityName',
    r.UPVOTES,
    r.WEBSITE,
    r.LEAFLEVEL,
    r.phone,
   t.ID,
    (SELECT 
   111.111 *
    DEGREES(ACOS(LEAST(1.0, COS(RADIANS(c1.LATITUDE))
         * COS(RADIANS((SELECT LATITUDE FROM city WHERE city.NAME = ? LIMIT 1)))
         * COS(RADIANS(c1.LONGITUDE - (SELECT LONGITUDE FROM city WHERE city.NAME = ? LIMIT 1)))
         + SIN(RADIANS(c1.LATITUDE))
         * SIN(RADIANS((SELECT LATITUDE FROM city WHERE city.NAME = ? LIMIT 1)))))) AS distance
  FROM city AS c1 WHERE c1.ID = c.ID) as `distance`
	FROM restaurant r JOIN city c USING (id) LEFT JOIN restaurant_tag rt ON (rt.ID_RESTAURANT = r.ID)  LEFT JOIN tag t ON (rt.ID_TAG = t.ID)
	) as subreq

WHERE `distance` < ?
ORDER BY `distance` ASC''';

    List<Object> args = [];
    if (city != null) args = [city, city, city, city, distanceKm];

    var results = await _distantAccess.executeSelectQuery(query, args);
    // dynamic last = null;
    Restaurant? currentRestaurant;
    for (var row in results) {
      int i = 0;
      var id = row[i++];
      print("id : " + id.toString());
      if (currentRestaurant != null && id == currentRestaurant.id) {
        currentRestaurant.addTag(Tools.findTag(row[11]));
        print("added tag " + Tools.findTag(row[11]).name);
      } else{ // First iteration of the restaurant
        var name = row[i++];
        print("name : " + name);
        var description = row[i++];
        var img = row[i++];
        var address = row[i++];
        var cityCode = row[i++];
        var city = row[i++];
        i++; //upvotes
        var webSite = row[i++];
        var leafLevel = row[i++];
        var phone = row[i++];
        var tagId = row[i++];
        List<int> tagList = tagId == null ? [] : [tagId];

        currentRestaurant = Restaurant(
            id: id,
            name: name,
            desc: description,
            imageURI: img,
            address: address,
            cityCode: cityCode,
            city: city,
            website: webSite,
            leafLevel: leafLevel,
            phone: phone,
            tagIds: tagList,
            schedules: [],
            isFav: false);
        restaurants.add(currentRestaurant);
      }
    }
    return restaurants;
    // //TODO: Test method !
    // var r1 = Restaurant(
    //     id: 1,
    //     name: "La Clairière",
    //     desc:
    //         "Cuisine saine et gourmande privilégiant les aliments BIO et locaux. Garantie sans huile de palme et sans produit d'origine animale.",
    //     fb: "LaClairiereLille",
    //     phone: "03 20 11 23 16",
    //     address: "75 Bd de la Liberté",
    //     cityCode: "59000",
    //     city: "Lille",
    //     imageURI:
    //         "https://scontent.fcdg1-1.fna.fbcdn.net/v/t1.18169-9/21731345_362591967511569_6909665824263452218_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=WJsRGbalGhMAX90XkBo&_nc_ht=scontent.fcdg1-1.fna&oh=00_AT_fvowCBUn-A84uC_T7T4UkwXQggfXBgfydKZMUPe2iLA&oe=6268502A",
    //     leafLevel: 2,
    //     tagIds: [4],
    //     isFav: true,
    //     schedules: [
    //       Schedule(idJour: 0, jour: "Lundi"),
    //       Schedule(
    //           idJour: 1,
    //           jour: "Mardi",
    //           opensAtPM: TimeOfDay(hour: 12, minute: 30),
    //           closesAtPM: TimeOfDay(hour: 14, minute: 30))
    //     ]);
    //
    // var r2 = Restaurant(
    //     id: 2,
    //     name: "Annie's Kitchen",
    //     desc:
    //         "Des plats français & du monde revisités, à la façon d'un estaminet. Blanquette, carbonade, ramen, poutine, tartare & co n'auront plus de secret pour vous.. & en version 100% végétale !",
    //     website: "https://www.annieskitchen.fr/",
    //     fb: "annieskitchenlille",
    //     phone: "06 78 54 90 57",
    //     address: "222 Rue Léon Gambetta",
    //     cityCode: "59000",
    //     city: "Lille",
    //     imageURI:
    //         "https://scontent.fcdg1-1.fna.fbcdn.net/v/t1.18169-9/27751512_165608680890200_4058145502370455996_n.jpg?_nc_cat=102&ccb=1-5&_nc_sid=174925&_nc_ohc=Ci8t__dM6H8AX-hfQ7w&_nc_ht=scontent.fcdg1-1.fna&oh=00_AT8XzPU0rIUk8BUQFQODxOme4PyfklrShltqZkovX80K7g&oe=62688694",
    //     leafLevel: 3,
    //     tagIds: [5, 4],
    //     isFav: false,
    //     schedules: [
    //       Schedule(idJour: 0, jour: "Lundi"),
    //       Schedule(
    //           idJour: 1,
    //           jour: "Mardi",
    //           opensAtAM: TimeOfDay(hour: 12, minute: 30),
    //           closesAtAM: TimeOfDay(hour: 14, minute: 30)),
    //       Schedule(idJour: 2, jour: "Mercredi",
    //           opensAtAM: TimeOfDay(hour: 12, minute: 0), closesAtAM: TimeOfDay(hour:13, minute: 0)),
    //       Schedule(idJour: 3, jour: "Jeudi",
    //           opensAtAM: TimeOfDay(hour: 12, minute: 0), closesAtAM: TimeOfDay(hour:13, minute: 0), opensAtPM: TimeOfDay(hour: 19, minute: 0), closesAtPM:TimeOfDay(hour: 21, minute: 0), ),
    //       Schedule(idJour: 4, jour: "Vendredi",
    //         opensAtAM: TimeOfDay(hour: 12, minute: 0), closesAtAM: TimeOfDay(hour:13, minute: 0), opensAtPM: TimeOfDay(hour: 19, minute: 0), closesAtPM:TimeOfDay(hour: 21, minute: 0), ),
    //       Schedule(idJour: 5, jour: "Samedi",
    //         opensAtAM: TimeOfDay(hour: 12, minute: 0), closesAtAM: TimeOfDay(hour:13, minute: 0), opensAtPM: TimeOfDay(hour: 19, minute: 0), closesAtPM:TimeOfDay(hour: 21, minute: 0), ),
    //       Schedule(idJour: 6, jour: "Mercredi",
    //         opensAtAM: TimeOfDay(hour: 12, minute: 0), closesAtAM: TimeOfDay(hour:13, minute: 0), opensAtPM: TimeOfDay(hour: 19, minute: 0), closesAtPM:TimeOfDay(hour: 21, minute: 0), ),
    //       Schedule(idJour: 7, jour: "Dimanche"),
    //
    //     ],
    // );
    //
    // var r3 = Restaurant(
    //   id: 3,
    //   name: "Pause.",
    //   desc:
    //       "Plats créatifs à tendance saine, dont des options vegan, pour ce café et restaurant cosy avec mini terrasse.",
    //   phone: "03 20 40 70 45",
    //   address: "25 Rue Pierre Mauroy",
    //   cityCode: "59000",
    //   city: "Lille",
    //   imageURI:
    //       "https://vegoresto.fr/wp-content/uploads/2017/05/restaurant-vegetarien-lille-pause0.png",
    //   leafLevel: 3,
    //   tagIds: [1, 2, 3, 4, 5],
    //   isFav: true,
    //   schedules: [],
    // );
    //
    // var r4 = Restaurant(
    //   id: 3,
    //   name: "L'atmosphère",
    //   desc:
    //       "Nos pizzas sont cuites sur pierre,notre pâte est faite maison chaque jour sans graisse animale,ni huile de palme,ni produits surgelés.",
    //   phone: "09 81 79 45 89",
    //   address: "12 Rue Henri Kolb",
    //   cityCode: "59000",
    //   city: "Lille",
    //   imageURI: "",
    //   leafLevel: 3,
    //   tagIds: [1],
    //   schedules: [],
    // );
    //
    // var r5 = Restaurant(
    //   id: 3,
    //   name: "Happy F'eat",
    //   desc:
    //       "Restaurant, salon de thé et bar découverte cosy pour un plat du jour unique, bio, sans gluten et sans lactose.",
    //   phone: "03 28 14 18 59",
    //   address: "106 Rue de l'Hôpital Militaire",
    //   cityCode: "59000",
    //   city: "Lille",
    //   leafLevel: 2,
    //   tagIds: [1, 2],
    //   isFav: false,
    //   schedules: [],
    // );
    //
    // return [r1, r2, r3, r4, r5];
  }

  /// Returns the [List] of [Restaurant] added to the user's favorites.
  List<Restaurant> getFavorites() {
    return [];
  }
}
