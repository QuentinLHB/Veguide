import 'package:flutter/material.dart';

class RestaurantImage extends StatelessWidget {
  RestaurantImage({Key? key, this.imageURI}) : super(key: key);
  String? imageURI;

  @override
  Widget build(BuildContext context) {
    return
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(3, 4), // changes position of shadow
              ),
            ],
          ),

          /// Restaurant's image.
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: imageURI != null &&
                imageURI!.isNotEmpty
                ? FadeInImage.assetNetwork(
                placeholder: 'assets/icons/icon.jpg',
                imageErrorBuilder: (context, object, trace) {
                  return Image.asset('assets/icons/icon.jpg');
                },
                image: imageURI!)
                : Image.asset('assets/icons/icon.jpg'),
          )
      );

  }
}
