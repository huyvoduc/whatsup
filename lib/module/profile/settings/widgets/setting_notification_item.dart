import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingNotificationItem extends StatefulWidget {
  final bool check;
  final String title;
  final TextStyle styleTitle;
  SettingNotificationItem({
    Key key,
    this.check = false,
    this.title,
    this.styleTitle,
  }) : super(key: key);
  @override
  _NotificationSettingItemState createState() =>
      _NotificationSettingItemState();
}

class _NotificationSettingItemState extends State<SettingNotificationItem> {
  bool check;
  @override
  void initState() {
    super.initState();
    setState(() {
      check = widget.check;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              widget.title ?? 'Title',
              style: widget.styleTitle ??
                  Theme.of(context).textTheme.body2.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CupertinoSwitch(
            value: check,
            onChanged: (bool value) {
              setState(() {
                check = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
