import 'package:flutter/material.dart';

// All text style based on design guideline
class ThemeText {
  // Default Text Style Following Guideline
  static const display4 = TextStyle(fontSize: 38, fontWeight: FontWeight.bold);
  static const display3 =
      TextStyle(fontSize: 32, fontWeight: FontWeight.normal);
  static const display2 =
      TextStyle(fontSize: 26, fontWeight: FontWeight.normal);
  static const display1 =
      TextStyle(fontSize: 22, fontWeight: FontWeight.normal);
  static const headline =
      TextStyle(fontSize: 20, fontWeight: FontWeight.normal);
  static const title = TextStyle(fontSize: 19, fontWeight: FontWeight.normal);
  static const body1 = TextStyle(fontSize: 18, fontWeight: FontWeight.normal);
  static const TextStyle body2 =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle subhead =
      TextStyle(fontSize: 17, fontWeight: FontWeight.normal);
  static const caption = TextStyle(fontSize: 15, fontWeight: FontWeight.normal);
  static const overline = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: 0.4);
  static const button = TextStyle(fontSize: 19, fontWeight: FontWeight.normal);

  static const TextStyle textStyleSubsNo15 = TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700);
  static TextStyle textStyleSubsYes15 = TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700);
  static TextStyle textStyleNormalWhite15 = TextStyle(color: Colors.white, fontSize: 15,);
  static TextStyle textStyleNormalBlue20 = TextStyle(color: Colors.blue, fontSize: 20, fontFamily: "AvenirLTStd");
  static TextStyle textStyleNormalRed20 = TextStyle(color: Colors.red, fontSize: 20, fontFamily: "AvenirLTStd");
  static TextStyle textStyleNormalWhite17 = TextStyle(color: Colors.white, fontSize: 17, fontFamily: "AvenirLTStd");
  static TextStyle textStyleNormal13GreyLv2 = TextStyle(color: Color(0xFF4e586e), fontSize: 13, fontFamily: "AvenirLTStd");
  static TextStyle textStyleNormalBlue15 = TextStyle(color: Colors.blue, fontSize: 15,);
  static TextStyle textStyleNormalGrey15 = TextStyle(color: Colors.grey, fontSize: 15,);
  static TextStyle textStyleNormalWhite13 = TextStyle(color: Colors.white, fontSize: 13);
  static TextStyle textStyleGrey13 = TextStyle(color: Colors.grey, fontSize: 13, fontFamily: "AvenirLTStd", fontWeight: FontWeight.w700);
  static TextStyle textStyleBlack13 = TextStyle(color: Colors.black, fontSize: 13, fontFamily: "AvenirLTStd", fontWeight: FontWeight.w700);
  static TextStyle textStyleBlack11 = TextStyle(color: Colors.black, fontSize: 11, fontFamily: "AvenirLTStd", fontWeight: FontWeight.w700);
  static TextStyle textStyleGrey11 = TextStyle(color: Colors.grey, fontSize: 11, fontFamily: "AvenirLTStd", fontWeight: FontWeight.w700);
  static TextStyle textStyleNormalBlack15 = TextStyle(color: Colors.black, fontSize: 15);

  static const rubberHeader = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static final TextStyle rubberSubhead = TextStyle(
    fontSize: 17,
    color: Colors.black.withOpacity(0.4),
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );

  static TextTheme getDefaultTextTheme() => const TextTheme(
      display4: ThemeText.display4,
      display3: ThemeText.display3,
      display2: ThemeText.display2,
      display1: ThemeText.display1,
      headline: ThemeText.headline,
      title: ThemeText.title,
      body1: ThemeText.body1,
      body2: ThemeText.body2,
      subhead: ThemeText.subhead,
      caption: ThemeText.caption,
      overline: ThemeText.overline,
      button: ThemeText.button);
}
