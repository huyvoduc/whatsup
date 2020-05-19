import 'package:flutter/material.dart';

import '../../common/constanst/package_constants.dart';
import '../../presentation/theme/theme_color.dart';

class WText extends StatefulWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  final TextStyle textStyle;

  const WText(this.text,
      {Key key,
      this.size,
      this.fontWeight,
      this.color,
      this.textStyle,
      this.textAlign,
      this.overflow,
      this.maxLines})
      : super(key: key);

  @override
  _WTextState createState() => _WTextState();
}

class _WTextState extends State<WText> {
  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    return Text(
      widget.text,
      textAlign: widget.textAlign ?? defaultTextStyle.textAlign,
      overflow: widget.overflow ?? defaultTextStyle.overflow,
      maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
      style: TextStyle(
              fontSize: widget.size,
              color: widget.color ?? AppColor.defaultTextColor,
              fontWeight: widget.fontWeight)
          .merge(widget.textStyle),
    );
  }
}
