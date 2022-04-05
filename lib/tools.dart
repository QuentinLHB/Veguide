import 'package:veguide/modele/tag.dart';
import 'package:flutter/material.dart';

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

  static void showAnimatedDialog(
          {required BuildContext context,
            required String title,
            List<Widget>? actions,
            required Widget content})=> showGeneralDialog(
      context: context,
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child:  AlertDialog(
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Center(child: Text(title)),
              content: content,
              actions: actions,
            ),
            ),
          );
      },
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return SizedBox.shrink();
      },
    );
}