import 'package:flutter/material.dart';

import 'package:whatsup/common/widgets/circle_image.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/module/profile/models/observable_history.dart';

class ObservableHistoryItem extends StatelessWidget {
  final ObservableHistory item;
  final double width;
  final TextStyle messageStyle;
  final TextStyle dateStyle;
  final TextStyle userCountStyle;

  const ObservableHistoryItem({
    Key key,
    this.item,
    @required this.width,
    this.messageStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    this.dateStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
    this.userCountStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.users == null || item.users.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleImage(
            image: Image.asset(
              item.users.first.avatar,
              fit: BoxFit.cover,
              height: width / 7,
              width: width / 7,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    getActivityMessage(),
                    style: messageStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  _buildListSubUser(context),
                  const SizedBox(
                    height: 5,
                  ),
                  _buildDatetimeString()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getActivityMessage() {
    final usersCount = item.users.length;
    final String lastUserName = item.users.last.name;
    final String subMessage =
        usersCount >= 2 ? 'và $usersCount người khác' : '';
    const String mainMessage = '\nđã ghé thăm trang cá nhân của bạn.';
    return '$lastUserName $subMessage $mainMessage';
  }

  Widget _buildListSubUser(BuildContext context) {
    final subUsersCount = item.users.length - 1;
    if (subUsersCount == 0) {
      return const SizedBox();
    }
    final List<Widget> listAvatar = [];

    final int userAvatar = subUsersCount > 3 ? 3 : subUsersCount;

    for (int i = 0; i < userAvatar; i++) {
      listAvatar.add(
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: CircleImage(
            image: Image.asset(
              item.users.first.avatar,
              fit: BoxFit.cover,
              height: width / 14,
              width: width / 14,
            ),
          ),
        ),
      );
    }
    if (subUsersCount > 3) {
      listAvatar.add(
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteList.listUser);
          },
          child: Container(
            height: width / 14,
            width: width / 14,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width / 28),
                color: Colors.white70),
            child: Align(
              child: Text(
                '+${subUsersCount - 3}',
                style: userCountStyle,
              ),
            ),
          ),
        ),
      );
    }
    return Row(
      children: listAvatar,
    );
  }

  Widget _buildDatetimeString() {
    return Text(
      _convertDatetimeString(),
      style: dateStyle,
    );
  }

  String _convertDatetimeString() {
    final DateTime now = DateTime.now();
    final int diffMilis =
        now.millisecondsSinceEpoch - item.date.millisecondsSinceEpoch;

    const int sixtySecondInMilis = 60000;
    const int sixtyMinuteInMilis = 3600000;
    const int oneDaySecondInMilis = 86400000;

    const int maxSecondInMilis = 54000; //59 seconds
    const int maxMinuteInMilis = 3540000; //59 minute
    const int maxHourInMilis = 82800000; //23 hour
    const int maxDayInMilis = 2592000000; //30day

    if (diffMilis < maxSecondInMilis) {
      return 'Vừa xong';
    } else if (diffMilis < maxMinuteInMilis) {
      return '${diffMilis ~/ sixtySecondInMilis} phút trước';
    } else if (diffMilis < maxHourInMilis) {
      return '${diffMilis ~/ sixtyMinuteInMilis} giờ trước';
    } else if (diffMilis < maxDayInMilis) {
      return '${diffMilis ~/ oneDaySecondInMilis} ngày trước';
    } else {
      return 'Vài tháng trước';
    }
  }
}
