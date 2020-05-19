import 'dart:math';
import 'package:flutter/material.dart';

class CircleImageOutline extends StatelessWidget {
  final double diameter;
  final String image;
  final Color borderColor;
  final double borderWidth;
  final bool isUrlImage;
  final double padding;
  final Color backgroundColor;

  const CircleImageOutline({
    Key key,
    this.diameter,
    this.image,
    this.borderColor,
    this.borderWidth = 4,
    this.isUrlImage,
    this.padding = 3,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: diameter,
      width: diameter,
      child: Container(
        height: diameter,
        width: diameter,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(diameter)),
            border: Border.all(color: borderColor, width: borderWidth),
            color: backgroundColor),
        child: CircleImage(
          image: isUrlImage
              ? Image.network(
                  image,
                  width: diameter,
                  height: diameter,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  image,
                  width: diameter,
                  height: diameter,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class CircleImage extends StatelessWidget {
  final Image image;
  const CircleImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(clipper: CircleClip(), child: image);
  }
}

class CircleClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
