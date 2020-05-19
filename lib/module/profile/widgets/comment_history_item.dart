import 'package:flutter/material.dart';

import 'package:whatsup/common/widgets/circle_image.dart';
import 'package:whatsup/module/profile/models/comment_history.dart';
import 'package:whatsup/common/extensions/string_extension.dart';

class CommentHistoryItem extends StatelessWidget {
  final CommentHistory item;
  final double width;
  final TextStyle messageStyle;
  final TextStyle dateStyle;

  const CommentHistoryItem({
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(item.posts == null || item.user == null) {
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
              item.user.avatar,
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
                    item.message,
                    style: messageStyle,
                  ),
                  _buildAttachedImage(),
                  const SizedBox(height: 5,),
                  _buildDatetimeString()
                ],
              ),
            ),
          ),
          Image.asset(
            item.posts.imagePath,
            fit: BoxFit.cover,
            height: width / 6,
            width: width / 6,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedImage() {
    if (item.image.isNullOrEmpty()) {
      return const SizedBox();
    }
    
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Image.asset(
        item.image,
        height: width / 3,
        fit: BoxFit.fitHeight,
      ),
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
      now.millisecondsSinceEpoch - item.datetime.millisecondsSinceEpoch;

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
