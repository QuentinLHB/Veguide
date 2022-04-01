import 'package:flutter/material.dart';
import 'package:veguide/view/widgets/fav_button.dart';

class PlusPage extends StatefulWidget {
  const PlusPage({Key? key}) : super(key: key);

  @override
  _PlusPageState createState() => _PlusPageState();
}

class _PlusPageState extends State<PlusPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: FavButton(isFav: false, onPressed: (){},));
  }
}
