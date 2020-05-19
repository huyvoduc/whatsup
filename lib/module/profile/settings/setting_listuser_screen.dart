import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:whatsup/module/profile/widgets/user_item.dart';
import '../../../presentation/theme/theme_color.dart';

class SettingListUserScreen extends StatefulWidget {
  @override
  _SettingListUserScreenState createState() => _SettingListUserScreenState();
}

class _SettingListUserScreenState extends State<SettingListUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Tài khoản bị chặn'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: AppColor.primaryColor,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                children: List.generate(20, (index) {
                  return GestureDetector(
                    onTap: _handleClickMe,
                    child: UserItem(),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            'Xác nhận bỏ chặn',
            style: Theme.of(context).textTheme.title.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
