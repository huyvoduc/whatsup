import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constanst/route_constants.dart';
import '../../../presentation/theme/theme_color.dart';
import 'widgets/setting_item.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Cài đặt',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildListItem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem() {
    return Container(
      child: Column(
        children: <Widget>[
          SettingItem(
            title: 'Thông báo',
            onTap: () {
              Navigator.pushNamed(context, RouteList.settingNotification);
            },
          ),
          SettingItem(
            title: 'Riêng tư',
            onTap: () {
              Navigator.pushNamed(context, RouteList.settingPrivacy);
            },
          ),
          SettingItem(
            title: 'Liên kết tài khoản',
            onTap: () {
              Navigator.pushNamed(context, RouteList.settingSocialNetwork);
            },
          ),
          SettingItem(
            title: 'Tài khoản đã chặn',
            onTap: () {
              Navigator.pushNamed(context, RouteList.settingListUser);
            },
          ),
          SettingItem(
            title: 'Đổi mật khẩu',
            onTap: _handleClickMe,
          )
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
            'Chúng tôi sẽ gửi hướng dẫn vào email của bạn',
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
