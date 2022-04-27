import 'package:veguide/modele/tag.dart';
import 'package:flutter/material.dart';

class Tools {
  static Tag findTag(int id) {
    switch (id) {
      case 1:
        return Tag.cheap;
      case 2:
        return Tag.rotativeMenu;
      case 3:
        return Tag.newPlace;
      case 4:
        return Tag.takeAway;
      case 5:
        return Tag.delivery;
      default:
        return Tag.cheap;
    }
  }

  static void showAnimatedDialog(
          {required BuildContext context,
          required String title,
          List<Widget>? actions,
          required Widget content}) =>
      showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, widget) {
          return _createDialog(a1, title, content, actions);
        },
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {
          return SizedBox.shrink();
        },
      );
  //
  // static void showStatefulAnimatedDialog(
  //     {required BuildContext context,
  //       required String title,
  //       List<Widget>? actions,
  //       required Widget content,
  //     }
  //     )=>
  //     showGeneralDialog(
  //       context: context,
  //       transitionBuilder: (context, a1, a2, widget) {
  //         return StatefulBuilder(builder:(context, setState){
  //
  //           return _createDialog(a1, title, content, actions);
  //         } ,);
  //
  //       },
  //       transitionDuration: Duration(milliseconds: 200),
  //       pageBuilder: (context, anim1, anim2) {
  //
  //         return SizedBox.shrink();
  //       },
  //     );

  static Widget _createDialog(Animation<double> scale, String title, Widget content,
          List<Widget>? actions) =>
      Transform.scale(
        scale: scale.value,
        child: Opacity(
          opacity: scale.value,
          child: AlertDialog(
            shape:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Center(child: Text(title)),
            content: content,
            actions: actions,
          ),
        ),
      );
}
