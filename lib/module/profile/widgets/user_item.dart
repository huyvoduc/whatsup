import 'package:flutter/material.dart';
import 'package:whatsup/common/widgets/circle_image.dart';
import 'package:whatsup/presentation/theme/theme_color.dart';

class UserItem extends StatelessWidget {
  final String avatar;
  final String userName;
  final String time;
  UserItem({
    Key key,
    this.avatar,
    this.userName,
    this.time,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        right: 20,
        left: 10,
        top: 10,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: CircleImage(
              image: Image.asset(
                avatar ?? 'assets/images/1.jpg',
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              child: Text(
                userName ?? 'Jim Nelson',
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            time ?? '2h',
            style: Theme.of(context).textTheme.title.copyWith(
                  color: AppColor.defaultTextColor,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
