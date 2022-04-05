import 'package:flutter/material.dart';
import 'package:veguide/modele/schedule.dart';
import 'package:veguide/modele/tag.dart';
import 'package:veguide/tools.dart';

class Restaurant {

  int _id;

  get id => _id;

  String _name;

  String get name => _name;

  String _desc;

  String get desc => _desc;

  String? _website;

  String? get website => _website;

  String? _fb;

  String? get fb {
    if(_fb != null) return "https://www.facebook.com/{}" + _fb!;
  else return null;}

  String _phone;

  String get phone => _phone;

  String _address;

  String get address => _address;

  String _cityCode;

  String get cityCode => _cityCode;

  String _city;

  String get city => _city;

  String? _imageURI;

  String? get imageURI => _imageURI;

  int _leafLevel;

  int get leafLevel => _leafLevel;

  List<Tag> _tags;
  List<Tag> get tags => _tags;

  bool _isFav = false;
  bool get isFav => _isFav;
  set isFav(bool isFav) => _isFav = isFav;

  List<Schedule> _schedules;
  List<Schedule> get schedules => _schedules;

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
    required String imageURI,
    required int leafLevel,
    required List<int> tagIds,
    required List<Schedule> shedules,
    bool? isFav,
    // required List<> //TODO: ajouter horaires
  }){
    List<Tag> tags = [];
    for(int tagId in tagIds){
      tags.add(Tools.findTag(tagId));
    }
    if(website != null){
      website = Tools.removeHttp(website);
    }
    if(fb != null){
      fb = Tools.removeHttp(fb);
    }
    return Restaurant._(id, name, desc, website, fb, phone, address, cityCode, city, imageURI, leafLevel, tags, shedules, isFav);
  }

  Restaurant._(this._id, this._name, this._desc, this._website, this._fb,
      this._phone, this._address, this._cityCode, this._city, this._imageURI, this._leafLevel, this._tags, this._schedules, bool? isFav){
    if(isFav != null) _isFav = isFav;
  }


}