import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
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
    required int leafLevel,
    List<Tag>? tags,
    int distanceKm: 15,
  }) async {
    List<Restaurant> restaurants = [];
    List<Object> args = [];

    if (city == null || city.isEmpty) {
      city = "Lille";
    }

    args = [city, city, city, leafLevel];

    // Optional where clauses
    String whereClause = "";

    // Optional tags filter (multiple)
    if (tags != null && tags.length > 0) {
      whereClause += "AND (";
      for (Tag tag in tags) {
        //and `tags` LIKE '%2%' OR `tags` LIKE '%4%'
        whereClause += "`tags` like '%?%' AND ";
        args.add(tag.id);
      }
      // Deletes the last 'OR' and closes the AND parenthesis;
      int index = whereClause.lastIndexOf("AND");
      whereClause = whereClause.replaceRange(index, null, ") ");
    }

    args.add(distanceKm);

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
     (
        SELECT 
   			111.111 *
    		DEGREES(ACOS(LEAST(1.0, COS(RADIANS(c1.LATITUDE))
        		* COS(RADIANS((SELECT LATITUDE FROM city WHERE city.NAME = ? LIMIT 1)))
         		* COS(RADIANS(c1.LONGITUDE - (SELECT LONGITUDE FROM city WHERE city.NAME = ? LIMIT 1)))
         		+ SIN(RADIANS(c1.LATITUDE))
         		* SIN(RADIANS((SELECT LATITUDE FROM city WHERE city.NAME = ? LIMIT 1)))))) AS degrees
  		FROM city AS c1 WHERE c1.ID = c.ID
    ) as `distance`
    
FROM restaurant r left JOIN city c ON (r.ID_CITY = c.ID) LEFT JOIN restaurant_tag rt ON (rt.ID_RESTAURANT = r.ID)  LEFT JOIN tag t ON (rt.ID_TAG = t.ID) 
WHERE  r.LEAFLEVEL >= ? 
GROUP BY r.ID ) as subreq

WHERE `distance` < ? ''';

    query += whereClause;

        query += '''
ORDER BY `distance` ASC, UPVOTES DESC''';

    var results = await _distantAccess.executeSelectQuery(query, args);

    // Restaurant? currentRestaurant;
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
          isFav: false));
    }
    return restaurants;
  }

  List<Tag> _getTagsFromBlob(Blob? blob){
    if(blob != null) return _getTagsFromConcatList(blob.toString());
    return [];
  }

  List<Tag> _getTagsFromConcatList(String tags) {
    List<Tag> tagList = [];
    var splittedTags = tags.split(",");
    for (String split in splittedTags) {
      try {
        int id = int.parse(split);
        tagList.add(Tools.findTag(id));
      } catch (e) {}
    }
    return tagList;
  }

  /// Returns the [List] of [Restaurant] added to the user's favorites.
  List<Restaurant> getFavorites() {
    return [];
  }
}
