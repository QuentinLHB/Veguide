import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:veguide/modele/distant_access.dart';
import 'package:veguide/modele/local_save.dart';
import 'package:veguide/modele/restaurant.dart';
import 'package:veguide/modele/schedule.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';
import 'package:location/location.dart';

class Controller {
  static final Controller _controller = Controller._privateConstructor();
  late DistantAccess _distantAccess;
  late LocalSave _localSave;

  /// Private unique instance of the controller.
  Controller._privateConstructor() {
    _distantAccess = DistantAccess();
    _localSave = LocalSave();
    // _distantAccess.executeSelectQuery("SELECT POSTAL_CODE FROM city", []).then((value) {
    //   for(var r in value){
    //     print(r[0]);
    //   }
    // });
  }

  /// Gets the single instance of the controller.
  factory Controller() {
    return _controller;
  }

  Future<bool> enablePosition() async {
    var location = Location.instance;
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return false;
    }
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  /// Returns the list of [Restaurant] searched by the user.
  Future<List<Restaurant>> searchRestaurants({
    String? city,
    int? leafLevel,
    List<Tag>? tags,
    int distanceKm: 15,
    bool usePosition = false,
  }) async {
    // Arguments used to replace the '?' in the query prep, in the same order as the query.
    List<Object> args = [];

    // Placeholder in case no city is sent.
    if (city == null || city.isEmpty) {
      city = "Lille";
    }



    String query = '''select * from(
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
   GROUP_CONCAT(t.ID) as 'tags',
   ''';

    query += await _createDistanceQuery(usePosition);
    query +=
        '''FROM restaurant r left JOIN city c ON (r.ID_CITY = c.ID) LEFT JOIN restaurant_tag rt ON (rt.ID_RESTAURANT = r.ID)  LEFT JOIN tag t ON (rt.ID_TAG = t.ID) 
WHERE  r.LEAFLEVEL >= ? 
GROUP BY r.ID ) as subreq

WHERE `distance` < ? 
''';

    // Leaf level adjustment, it's at least 1 and at most 3.
    if (leafLevel == null || leafLevel > 3 || leafLevel < 1) {
      leafLevel = 1;
    }

    // If the phone position is used, there is no need to use the city. Else,
    if (!usePosition) args.addAll([city, city, city]);

    args.add(leafLevel);
    args.add(distanceKm);

    // Optional where clauses
    String whereClause = "";

    // Optional tags filter (multiple)
    if (tags != null && tags.length > 0) {
      whereClause += "AND (";
      for (Tag tag in tags) {
        // Usage of '?' doesn't work since it's in a String (interpreted as part of it).
        // SQL Injection shouldn't work there, though.
        whereClause += "`tags` like '%${tag.id}%' AND ";
      }
      // Deletes the last 'AND' and closes the AND parenthesis;
      int index = whereClause.lastIndexOf("AND");
      whereClause = whereClause.replaceRange(index, null, ") ");
    }

    query += whereClause;

    query += '''
ORDER BY `distance` ASC, UPVOTES DESC''';

    var results = await _distantAccess.executeSelectQuery(query, args);
    if(results != null) return _createRestaurantsFromQueryResult(results);
    else return [];
  }

  Future<String> _createDistanceQuery(bool usePosition) async {
    if (usePosition && await enablePosition()) {
      var location = Location.instance;
      var position = await location.getLocation();

      return '''(
        SELECT 
   			111.111 *
    		DEGREES(ACOS(LEAST(1.0, COS(RADIANS(c1.LATITUDE))
        		* COS(RADIANS(${position.latitude}))
         		* COS(RADIANS(c1.LONGITUDE - ${position.longitude}))
         		+ SIN(RADIANS(c1.LATITUDE))
         		* SIN(RADIANS(${position.latitude}))))) AS degrees
  		FROM city AS c1 WHERE c1.ID = c.ID
    ) as `distance`
    ''';
    } else {
      return '''(
        SELECT 
   			111.111 *
    		DEGREES(ACOS(LEAST(1.0, COS(RADIANS(c1.LATITUDE))
        		* COS(RADIANS((SELECT LATITUDE FROM city WHERE city.NAME = ? LIMIT 1)))
         		* COS(RADIANS(c1.LONGITUDE - (SELECT LONGITUDE FROM city WHERE city.NAME = ? LIMIT 1)))
         		+ SIN(RADIANS(c1.LATITUDE))
         		* SIN(RADIANS((SELECT LATITUDE FROM city WHERE city.NAME = ? LIMIT 1)))))) AS degrees
  		FROM city AS c1 WHERE c1.ID = c.ID
    ) as `distance`
    ''';
    }
  }

  /// Takes a binary large object [blob], separated
  /// by commas (i.e. "1,2,3'), and returns a list of [Tag]s.
  List<Tag> _getTagsFromBlob(Blob? blob) {
    List<Tag> tagList = [];
    if (blob != null) {
      var splitTags = blob.toString().split(",");
      for (String split in splitTags) {
        try {
          int id = int.parse(split);
          tagList.add(Tools.findTag(id));
        } catch (e) {}
      }
    }
    return [];
  }

  /// Returns the [List] of [Restaurant] added to the user's favorites.
  Future<List<Restaurant>> getFavorites() async {
    List<int> favIds = await _localSave.readIds();

    if (favIds.isEmpty) return [];

    String query = '''
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
   GROUP_CONCAT(t.ID) as 'tags'

FROM restaurant r left JOIN city c ON (r.ID_CITY = c.ID) LEFT JOIN restaurant_tag rt ON (rt.ID_RESTAURANT = r.ID)  LEFT JOIN tag t ON (rt.ID_TAG = t.ID)

WHERE ''';

    String whereClause = "";
    for (int id in favIds) {
      whereClause += "r.id = ? OR ";
    }

    int index = whereClause.lastIndexOf("OR");
    whereClause = whereClause.replaceRange(index, null, "");

    query += whereClause;

    query += '''GROUP BY r.ID''';

    var results = await _distantAccess.executeSelectQuery(query, favIds);

    if(results != null) return _createRestaurantsFromQueryResult(results);
    else return [];
  }

  Future<List<Restaurant>> _createRestaurantsFromQueryResult(
      Results results) async {
    List<Restaurant> restaurants = [];
    for (var row in results) {
      int i = 0;
      var id = row[i++];
      var name = row[i++];
      var description = row[i++];
      var img = row[i++];
      var address = row[i++];
      var cityCode = row[i++];
      var city = row[i++];
      i++; //upvotes
      var webSite = row[i++];
      var leafLevel = row[i++];
      var phone = row[i++];
      List<Tag> tagList = _getTagsFromBlob(row[i++]);
      bool isFav = await _localSave.isInFile(id);
      restaurants.add(Restaurant(
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
          tags: tagList,
          schedules: [],
          isFav: isFav));
    }
    return restaurants;
  }

  Future<void> addToFavorites(Restaurant restaurant) async {
    await _localSave.addId(restaurant.id);
    restaurant.isFav = !restaurant.isFav;
  }

  Future<void> removeFromFavorites(Restaurant restaurant) async {
    await _localSave.removeId(restaurant.id);
    restaurant.isFav = !restaurant.isFav;
  }
}
