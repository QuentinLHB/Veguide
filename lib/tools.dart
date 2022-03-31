import 'package:veguide/modele/tag.dart';

class Tools{

  static Tag findTag(int id){
    switch(id){
      case 1: return Tag.cheap;
      case 2: return Tag.rotativeMenu;
      case 3: return Tag.newPlace;
      case 4: return Tag.takeAway;
      case 5: return Tag.delivery;
      default: return Tag.cheap;
    }
  }

  static String removeHttp(String url){
    // if(url.contains("https://")){
    //   return url.split("https://")[1];
    // }
    // else if(url.contains("http://")){
    //   return url.split("http://")[1];
    // }else{
      return url;
    // }

  }
}