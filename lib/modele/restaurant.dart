import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veguide/modele/schedule.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';

/// Stores a restaurant's data.
class Restaurant {

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
    if(_fb != null) return "https://www.facebook.com/${_fb}";
  else return null;}

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

  List<Tag> _tags;

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
    required List<int> tagIds,
    required List<Schedule> schedules,
    bool? isFav,
  }){
    List<Tag> tags = [];
    for(int tagId in tagIds){
      tags.add(Tools.findTag(tagId));
    }
    return Restaurant._(id, name, desc, website, fb, phone, address, cityCode, city, imageURI, leafLevel, tags, schedules, isFav);
  }

  Restaurant._(this._id, this._name, this._desc, this._website, this._fb,
      this._phone, this._address, this._cityCode, this._city, this._imageURI, this._leafLevel, this._tags, this._schedules, bool? isFav){
    if(isFav != null) _isFav = isFav;
  }


}