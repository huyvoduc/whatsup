import 'package:whatsup/module/profile/models/posts.dart';
import 'package:whatsup/module/profile/models/user.dart';

enum NotificationType {
  like,
  follow,
  comment,
  mention,
}

class NotificationData {
  User from;
  NotificationType type;
  Posts posts;
  String message;
  DateTime date;

  NotificationData(
    this.from,
    this.type,
    this.posts,
    this.message,
    this.date,
  );
}
