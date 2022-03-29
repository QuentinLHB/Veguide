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

  String? get fb => _fb;

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
  }){
    return Restaurant._(id, name, desc, website, fb, phone, address, cityCode, city, imageURI, leafLevel);
  }

  Restaurant._(this._id, this._name, this._desc, this._website, this._fb,
      this._phone, this._address, this._cityCode, this._city, this._imageURI, this._leafLevel);
}