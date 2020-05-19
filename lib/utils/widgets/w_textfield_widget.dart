import 'package:flutter/material.dart';

import '../../presentation/theme/theme_color.dart';

class WTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String errorText;

  const WTextField(
    this.controller, {
    Key key,
    this.hintText = '',
    this.errorText,
  }) : super(key: key);

  @override
  _WTextFieldState createState() => _WTextFieldState();
}

class _WTextFieldState extends State<WTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.lineTextColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.lineTextColor),
        ),
        errorText: widget.errorText,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontSize: 15,
          color: AppColor.defaultTextColor,
        ),
      ),
    );
  }
}
