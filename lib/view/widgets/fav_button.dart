import 'package:flutter/material.dart';

class FavButton extends StatefulWidget {
  FavButton({Key? key, required this.isFav, required this.onPressed})
      : super(key: key);

  bool isFav;
  VoidCallback onPressed;

  @override
  _FavButtonState createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
      value: 1.0,
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      alignment: Alignment.topRight,
      iconSize: 25,
        onPressed: () {
          _animate();
          setState(() {});
          widget.onPressed();
        },
        icon: ScaleTransition(
          scale: _animationController,
          child: Icon(
            widget.isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: Colors.red.shade800.withOpacity(0.6),
          ),
        ));
  }

  void _animate() {
    _animationController.reverse().then((value) {
      setState(() {
        widget.isFav = !widget.isFav;
      });
    }).then((value) => _animationController.forward());
  }
}
