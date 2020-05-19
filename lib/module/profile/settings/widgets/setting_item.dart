import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Function onTap;
  SettingItem({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black12,
            ),
          ),
        ),
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 30,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
