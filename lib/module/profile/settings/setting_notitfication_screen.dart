import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../presentation/theme/theme_color.dart';
import 'widgets/setting_notification_item.dart';

class SettingNotificationScreen extends StatefulWidget {
  @override
  _SettingNotificationScreenState createState() =>
      _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen> {
  bool light = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Cài đặt thông báo'),
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
        actions: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  'Lưu',
                  style: Theme.of(context).textTheme.body2.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          )
        ],
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
                children: <Widget>[
                  _buildMyContent(context),
                  _buildHint(context),
                  _buildOther(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 10,
            bottom: 10,
          ),
          child: Text(
            'NỘI DUNG CỦA BẠN',
            style: Theme.of(context).textTheme.body2.copyWith(
                  color: AppColor.defaultTextColor,
                  fontSize: 16,
                ),
          ),
        ),
        Container(
          color: AppColor.lineTextColor,
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SettingNotificationItem(
                check: false,
                title: 'Biểu cảm',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Bình luận',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Nội dung trở nên phổ biến',
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHint(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 10,
            bottom: 10,
          ),
          child: Text(
            'GỢI Ý',
            style: Theme.of(context).textTheme.body2.copyWith(
                  color: AppColor.defaultTextColor,
                  fontSize: 16,
                ),
          ),
        ),
        Container(
          color: AppColor.lineTextColor,
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Column(
            children: <Widget>[
              SettingNotificationItem(
                check: false,
                title: 'Nội dung có thể bạn thích',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Nội dung đang phổ biến',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Gợi ý người dùng',
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOther(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 10,
            bottom: 10,
          ),
          child: Text(
            'KHÁC',
            style: Theme.of(context).textTheme.body2.copyWith(
                  color: AppColor.defaultTextColor,
                  fontSize: 16,
                ),
          ),
        ),
        Container(
          color: AppColor.lineTextColor,
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Column(
            children: <Widget>[
              SettingNotificationItem(
                check: false,
                title: 'Trả lời về bình luận của bạn',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Biểu cảm lên bình luận của bạn',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Nhắc đến bạn trong một bình luận',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Tin nhắn',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Có người đăng ký mới',
              ),
              SettingNotificationItem(
                check: false,
                title: 'Có người vào trang cá nhân của bạn',
              ),
            ],
          ),
        )
      ],
    );
  }
}
