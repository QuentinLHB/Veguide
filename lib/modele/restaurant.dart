import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:json_serializable/json_serializable.dart';
import 'package:veguide/modele/schedule.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';
import 'package:collection/collection.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'restaurant.g.dart';

/// Stores a restaurant's data.
// @JsonSerializable()
class Restaurant {
  /// When [true], the object can't be modified.
  /// The value being retrieved from a data based, it is not meant to be modified.
  /// The only way for this value to be set to true is to use the [clone] method,
  /// creating an editable clone.
  bool _locked = true;

  int _id;

  /// Database's id
  get id => _id;

  String _name;

  /// Name
  String get name => _name;

  String _desc;

  /// Description
  String get desc => _desc;

  String? _website;

  /// Full website's URL (http://www.(...).com)
  String? get website => _website;

  String? _fb;

  /// Full facebook's url (https://www.facebook.com/(...))
  String? get fb {
    if (_fb != null)
      return "https://www.facebook.com/${_fb}";
    else
      return null;
  }

  /// Last part of the facebook's url, after facebook.com/.
  String? get fbSuffix => _fb;

  String _phone;

  /// Phone number.
  String get phone => _phone;

  String _address;

  /// Address, without city.
  String get address => _address;

  String _cityCode;

  /// Postal code (i.e 59000)
  String get cityCode => _cityCode;

  String _city;

  /// City name.
  String get city => _city;

  String? _imageURI;

  String? get imageURI => _imageURI;

  int _leafLevel;

  /// Leaf level between 1 and 3.
  /// * 1: Minimum amount of vegan options
  /// * 2: Multiple amount of vegan options
  /// * 3 : 100% vegan
  int get leafLevel => _leafLevel;

  final List<Tag> _tags;

  /// Tags
  List<Tag> get tags => _tags;

  bool _isFav = false;

  /// True if [this] has been added to the user's favorites.
  bool get isFav => _isFav;

  set isFav(bool isFav) => _isFav = isFav;

  /// Schedule for every day (one object per day).
  List<Schedule> _schedules;

  List<Schedule> get schedules => _schedules;

  /// Creates a restaurant.
  /// [name], [desc], [phone], [address], [city], [cityCode], and [leafLevel] are mandatory fields.
  /// [tagIds] and [schedules] can be empty lists but are mandatory as well.
  /// [website], [fb] and [imageURI] are optional.
  factory Restaurant({
    required int id,
    required String name,
    required String desc,
    String? website,
    String? fb,
    required String phone,
    required String address,
    required String cityCode,
    required String city,
    String? imageURI,
    required int leafLevel,
    required List<Tag> tags,
    required List<Schedule> schedules,
    bool? isFav,
  }) {
    return Restaurant._(id, name, desc, website, fb, phone, address, cityCode,
        city, imageURI, leafLevel, tags, schedules, isFav);
  }

  Restaurant._(
      this._id,
      this._name,
      this._desc,
      this._website,
      this._fb,
      this._phone,
      this._address,
      this._cityCode,
      this._city,
      this._imageURI,
      this._leafLevel,
      this._tags,
      this._schedules,
      bool? isFav,
      {bool locked = true}) {
    if (isFav != null) _isFav = isFav;
    _locked = locked;
  }

  /// Creates an editable clone instance of [this].
  Restaurant clone() {
    List<Schedule> schedules = [];
    _schedules.forEach((element) {
      schedules.add(element.clone());
    });
    return Restaurant._(
        _id,
        _name,
        _desc,
        _website,
        _fb,
        _phone,
        _address,
        _cityCode,
        _city,
        _imageURI,
        _leafLevel,
        List.from(_tags),
        schedules,
        isFav,
        locked: false);
  }

  /// Returns true when the [tag] exists in the [_restaurant]'s [Tag] list.
  bool isTagToggled(Tag tag) {
    return _tags.firstWhereOrNull((Tag restauTag) {
          return restauTag == tag;
        }) !=
        null;
  }

  /// Removes a [Tag] (if using a clone)
  /// see [clone].
  void removeTag(Tag tag) {
    if(!_locked) _tags.remove(tag);
  }

  /// Adds a [Tag] (if using a clone)
  /// see [clone].
  void addTag(Tag tag) {
    // if(!_locked) _tags.add(tag);
    _tags.add(tag);
  }


  /// Sets the name (if using a clone)
  ///  see [clone].
  set name(String value) {
    if (!_locked) _name = value;
  }

  /// Sets the schedules (if using a clone)
   ///  see [clone].
  set schedules(List<Schedule> value) {
    if (!_locked) _schedules = value;
  }

  /// Sets the leaf level (if using a clone)
  ///  see [clone].
  set leafLevel(int value) {
    if(!_locked)_leafLevel = value;
  }

  /// Sets the image URI (if using a clone)
   ///  see [clone].
  set imageURI(String? value) {
    if(!_locked)_imageURI = value;
  }

  /// Sets the city (if using a clone)
  ///  see [clone].
  set city(String value) {
    if(!_locked)_city = value;
  }

  /// Sets the city code (if using a clone)
  ///  see [clone].
  set cityCode(String value) {
    if(!_locked)_cityCode = value;
  }

  /// Sets the address (if using a clone)
  ///  see [clone].
  set address(String value) {
    if(!_locked)_address = value;
  }

  /// Sets the phone number (if using a clone)
  ///  see [clone].
  set phone(String value) {
    if(!_locked) _phone = value;
  }

  /// Sets the facebook id (i.e. 'restaurant', not the whole url) (if using a clone)
  ///  see [clone].
  set fb(String? value) {
    if(!_locked)_fb = value;
  }

  /// Sets the website URL (if using a clone)
   ///  see [clone].
  set website(String? value) {
    if(!_locked)_website = value;
  }

  /// Sets the restaurant description (if using a clone)
  ///  see [clone].
  set desc(String value) {
    if(!_locked)_desc = value;
  }

  /// Gets a formated [String] displaying every [Schedule].
  /// For example :
  /// "Lundi : 12:00 - 14:00 / 18:00 - 21:30
  /// Mardi : 12:00 - 14:00
  /// (...)"
  String get scheduleDisplay {
    String display = "";
    for (Schedule schedule in _schedules) {
      display += schedule.toString() + "\n";
    }
    return display;
  }

  // Restaurant.fromJson(Map<String, dynamic> json)
  //     : _id = json['id'],
  //       email = json['email'];
  //
  // Map<String, dynamic> toJson() => {
  //   'name': name,
  //   'email': email,
  // };

  // /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  // /// factory.
  // factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
  //
  // /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  // Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
