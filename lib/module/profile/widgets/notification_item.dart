import 'package:flutter/material.dart';
import 'package:whatsup/common/widgets/circle_image.dart';
import 'package:whatsup/module/profile/models/notification_data.dart';

class NotificationItem extends StatelessWidget {
  final NotificationData item;
  final double width;
  final TextStyle messageStyle;
  final TextStyle dateStyle;
  final TextStyle commentStyle;

  const NotificationItem({
    Key key,
    this.item,
    @required this.width,
    this.messageStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16
    ),
    this.dateStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 12
    ),
    this.commentStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(item.from == null) {
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
              item.from.avatar,
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
                    _buildNotificationMessage(),
                    style: messageStyle,
                  ),
                  const SizedBox(height: 5,),
                  _buildComment(),
                  const SizedBox(height: 5,),
                  _buildDatetimeString()
                ],
              ),
            ),
          ),
          _buildSubImage(),
        ],
      ),
    );
  }

  String _buildNotificationMessage() {
    final userTag = '@${item.from.tag}';
    final userName = '${item.from.name}';
    switch (item.type) {
      case NotificationType.comment:
        return '$userTag \nđã bình luận về một bài viết';
      case NotificationType.like:
        return '$userName \nđãthích ảnh của bạn';
      case NotificationType.follow:
        return '$userName \nđã đăng ký theo dõi bạn';
      case NotificationType.mention:
        return '$userName \nđã nhắc đến bạn trong một bài viết';
      default: return 'Unknown';
    }
  }

  Widget _buildSubImage() {
    switch (item.type) {
      case NotificationType.follow:
        return const SizedBox();
      case NotificationType.comment:
      case NotificationType.like:
      case NotificationType.mention:
        return Image.asset(
          item.posts.imagePath,
          fit: BoxFit.cover,
          height: width / 6,
          width: width / 6,
        );
      default: return const SizedBox();
    }
  }

  Widget _buildComment() {
    switch (item.type) {
      case NotificationType.follow:
      case NotificationType.like:
      case NotificationType.mention:
        return const SizedBox();
      case NotificationType.comment:
        return Text(
          item.message,
          style: commentStyle,
        );
      default: return const SizedBox();
    }
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
