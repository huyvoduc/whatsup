import 'package:flutter/material.dart';

import 'package:whatsup/common/widgets/dialogs/notify_dialog.dart';
import 'package:whatsup/common/widgets/simple_button.dart';
import 'package:whatsup/presentation/theme/theme_color.dart';

dynamic errorInternet({
  String titlePopup = 'Oh No!',
  TextStyle styleTextTitle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  TextStyle styleTextContent = const TextStyle(
    fontSize: 13,
    color: Colors.black45,
  ),
  TextStyle styleTextButton = const TextStyle(
    color: Colors.white,
  ),
  String content =
      'No internet connection found.\n Check your connection and try again',
  String titleButton = 'Try again',
  Function() onTap,
  Icon iconPopup = const Icon(Icons.wifi, color: Colors.red, size: 150),
  double width = 250,
  double height = 280,
  List<Color> buttonBg = const [Colors.redAccent, Colors.redAccent],
}) {
  return NotifyDialog(
    iconPopup: iconPopup,
    titlePopup: Text(
      titlePopup,
      style: styleTextTitle,
    ),
    content: Text(
      content,
      style: styleTextContent,
      textAlign: TextAlign.center,
    ),
    buttonActions: [
      SimpleButton(
        width: 120,
        height: 45,
        borderRadius: 8,
        textStyle: styleTextButton,
        text: titleButton,
        bgColors: buttonBg,
        onPressed: onTap,
      )
    ],
    width: width,
    height: height,
  );
}

dynamic errorNotiedErrorPopup({
  String titlePopup = 'Oh No!',
  TextStyle styleTextTitle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  TextStyle styleTextContent = const TextStyle(
    fontSize: 16,
    color: Colors.grey,
  ),
  TextStyle styleTextButton = const TextStyle(
    color: Colors.white,
  ),
  String content = 'Something went wrong!',
  String titleButton = 'Close',
  Function() onTap,
  Icon iconPopup = const Icon(
    Icons.error,
    color: Colors.red,
    size: 100,
  ),
  double width = 250,
  double height = 280,
}) {
  return NotifyDialog(
    iconPopup: iconPopup,
    titlePopup: Text(
      titlePopup,
      style: styleTextTitle,
    ),
    content: Text(
      content,
      style: styleTextContent,
      textAlign: TextAlign.center,
    ),
    buttonActions: [
      SimpleButton(
        width: 120,
        height: 45,
        borderRadius: 8,
        textStyle: styleTextButton,
        text: titleButton,
        bgColors: const [Colors.redAccent, Colors.redAccent],
        onPressed: onTap,
      )
    ],
    width: width,
    height: height,
  );
}

dynamic errorNotiedPopup({
  String titlePopup = 'Attention',
  TextStyle styleTextTitle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  TextStyle styleTextContent = const TextStyle(
    fontSize: 16,
    color: Colors.grey,
  ),
  TextStyle styleTextButton = const TextStyle(
    color: Colors.white,
  ),
  @required String content,
  String titleButton = 'Close',
  Function() onTap,
  Icon iconPopup = const Icon(
    Icons.warning,
    color: AppColor.primaryColor,
    size: 100,
  ),
  double width = 250,
  double height = 280,
}) {
  final simpleButton = SimpleButton(
    width: 120,
    height: 45,
    borderRadius: 8,
    textStyle: styleTextButton,
    text: titleButton,
    bgColors: const [AppColor.primaryColor, AppColor.primaryColor],
    onPressed: onTap,
  );

  return NotifyDialog(
    iconPopup: iconPopup,
    titlePopup: Text(
      titlePopup,
      style: styleTextTitle,
    ),
    content: Text(
      content,
      style: styleTextContent,
      textAlign: TextAlign.center,
    ),
    buttonActions: [simpleButton],
    width: width,
    height: height,
  );
}

dynamic successNotiedPopup({
  String titlePopup = 'Successfully',
  TextStyle styleTextTitle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  TextStyle styleTextContent = const TextStyle(
    fontSize: 16,
    color: Colors.grey,
  ),
  TextStyle styleTextButton = const TextStyle(
    color: Colors.white,
  ),
  @required String content,
  String titleButton = 'Close',
  Function() onTap,
  Icon iconPopup = const Icon(
    Icons.check_circle,
    color: Colors.white,
    size: 100,
  ),
  double width = 250,
  double height = 280,
}) {
  final simpleButton = SimpleButton(
    width: 120,
    height: 45,
    borderRadius: 8,
    textStyle: styleTextButton,
    text: titleButton,
    bgColors: const [Colors.white30, Colors.white30],
    onPressed: onTap,
  );

  return NotifyDialog(
    iconPopup: iconPopup,
    titlePopup: Text(
      titlePopup,
      style: styleTextTitle,
    ),
    content: Text(
      content,
      style: styleTextContent,
      textAlign: TextAlign.center,
    ),
    buttonActions: [simpleButton],
    width: width,
    height: height,
  );
}
