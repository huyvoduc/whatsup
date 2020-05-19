import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../presentation/theme/theme_color.dart';
import 'widgets/setting_notification_item.dart';

class SettingPrivacyScreen extends StatefulWidget {
  @override
  _SettingPrivacyScreenState createState() => _SettingPrivacyScreenState();
}

class _SettingPrivacyScreenState extends State<SettingPrivacyScreen> {
  String typePersonSendMess = 'Mọi người';
  void setTypePersonSendMess(String type) {
    setState(() {
      typePersonSendMess = type;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Quyền riêng tư'),
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
                  _buildPrivacySendMessage(),
                  _buildFilterContentCheckBox(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySendMessage() {
    return GestureDetector(
      onTap: _showModalPersonSendMess,
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          color: AppColor.lineTextColor,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Ai có thể gửi tin nhắn cho tôi',
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    typePersonSendMess,
                    style: Theme.of(context).textTheme.title.copyWith(
                          color: AppColor.defaultTextColor,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterContentCheckBox(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: AppColor.lineTextColor,
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: SettingNotificationItem(
            title: 'Chế độ lọc nội dung',
            check: false,
            styleTitle: Theme.of(context).textTheme.title.copyWith(
                  color: AppColor.defaultTextColor,
                  fontSize: 20,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 10,
            bottom: 10,
          ),
          child: Text(
            '''Khi chế độ lọc nội dung được bật, bạn sẽ chỉ nhìn thấy những bài viết được chấp thuận bởi quản trị viên''',
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: AppColor.defaultTextColor,
                  fontSize: 12,
                ),
          ),
        ),
        GestureDetector(
          onTap: _handleClickMe,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: AppColor.lineTextColor,
            padding: const EdgeInsets.only(
              left: 20,
              top: 10,
              bottom: 10,
            ),
            child: Text(
              'Xoá hết lịch sử đã xem',
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.red,
                    fontSize: 20,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showModalPersonSendMess() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () => setTypePersonSendMess('Mọi người'),
              child: const Text(
                'Mọi người',
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () => setTypePersonSendMess('Bạn bè'),
              child: const Text(
                'Chỉ bạn bè',
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () => setTypePersonSendMess('Không ai cả'),
              child: const Text(
                'Không ai cả',
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            'Bạn có chắc chắn muốn xóa hết lịch sử đã xem?',
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
              child: const Text('Xoá'),
            ),
          ],
        );
      },
    );
  }
}
