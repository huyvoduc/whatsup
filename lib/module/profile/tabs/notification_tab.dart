import 'package:flutter/material.dart';
import 'package:whatsup/module/profile/__mock__/notification_mock_data.dart';
import 'package:whatsup/module/profile/widgets/notification_item.dart';

class NotificationTab extends StatefulWidget {
  final double width;

  const NotificationTab({Key key, @required this.width}) : super(key: key);

  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: widget.width,
        child: Column(
          children: notificationDatas
              .map<NotificationItem>(
                (item) => NotificationItem(
                  item: item,
                  width: widget.width,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
