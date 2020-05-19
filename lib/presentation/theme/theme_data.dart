import 'package:flutter/material.dart';

import 'theme_color.dart';
import 'theme_text.dart';

ThemeData appTheme(BuildContext context) => ThemeData(
      fontFamily: 'AvenirLTStd',
      primaryColor: AppColor.primaryColor,
      accentColor: AppColor.white,
      textTheme: ThemeText.getDefaultTextTheme(),
      scaffoldBackgroundColor: AppColor.primaryColor,
      buttonTheme: ButtonThemeData(
        //update and enhance in screens where necessary
        buttonColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      // scaffoldBackgroundColor: AppColor.white,
      // iconTheme: ThemeIcon.getDefaultIconTheme(),
      // appBarTheme: const AppBarTheme(color: AppColor.white, elevation: 0),
      // dialogTheme: ThemeDialog.getDefaultDialogTheme(),
      // snackBarTheme: ThemeSnackBar.getDefaultSnackBarTheme(),
      // inputDecorationTheme: ThemeInputDecoration.get(context),
      // toggleableActiveColor: AppColor.primaryColor,
    );
