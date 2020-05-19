import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final double height;
  final double width;
  final List<Color> bgColors;
  final String text;
  final TextStyle textStyle;
  final Function onPressed;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  const SimpleButton({
    Key key, 
    this.height, 
    this.width, 
    this.bgColors = const [Color(0xffb5f959), Color(0xff69ae08)], 
    this.text, 
    this.onPressed, 
    this.textStyle = const TextStyle(
      color: Colors.white, 
      fontSize: 16, 
      fontWeight: FontWeight.bold
    ),
    this.borderRadius,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? height),
        border: Border.all(
            width: borderWidth,
            color: borderColor
        ),
        gradient: LinearGradient(
          colors: bgColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? height)
        ),
        elevation: 0.0,
        onPressed: onPressed,
        child: Text(text,
          style: textStyle,
        ),
      )
    );
  }
}