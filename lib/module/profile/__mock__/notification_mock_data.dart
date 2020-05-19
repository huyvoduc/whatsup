import 'package:whatsup/module/profile/models/notification_data.dart';
import 'package:whatsup/module/profile/models/posts.dart';
import 'package:whatsup/module/profile/models/user.dart';

List<NotificationData> notificationDatas = [
  NotificationData(
    User (
      'Ngọc Trinh',
      'assets/images/cover.jpg',
      'ngoctrinh'
    ),
    NotificationType.follow,
    null,
    null,
    DateTime(2020, 02, 24, 16, 7, 26),
  ),
  NotificationData(
    User (
      'Ngọc Trinh',
      'assets/images/cover.jpg',
      'ngoctrinh'
    ),
    NotificationType.like,
    Posts('assets/images/1.jpg', 1, 1),
    '',
    DateTime(2020, 02, 24, 14, 34, 26),
  ),
  NotificationData(
    User (
      'Ngọc Trinh',
      'assets/images/cover.jpg',
      'ngoctrinh'
    ),
    NotificationType.mention,
    Posts('assets/images/1.jpg', 1, 1),
    null,
    DateTime(2020, 02, 24, 12, 23, 26),
  ),
  NotificationData(
    User (
      'Ngọc Trinh',
      'assets/images/cover.jpg',
      'ngoctrinh'
    ),
    NotificationType.comment,
    Posts('assets/images/1.jpg', 1, 1),
    "This is a comment content. I don't know what is this",
    DateTime(2020, 02, 24, 10, 23, 26),
  ),
  NotificationData(
    User (
      'Ngọc Trinh',
      'assets/images/cover.jpg',
      'ngoctrinh'
    ),
    NotificationType.follow,
    null,
    null,
    DateTime(2020, 02, 24, 9, 7, 26),
  ),
  NotificationData(
    User (
      'Ngọc Trinh',
      'assets/images/cover.jpg',
      'ngoctrinh'
    ),
    NotificationType.like,
    Posts('assets/images/1.jpg', 1, 1),
    '',
    DateTime(2020, 02, 24, 8, 34, 26),
  ),
  NotificationData(
    User (
      'Ngọc Trinh',
      'assets/images/cover.jpg',
      'ngoctrinh'
    ),
    NotificationType.mention,
    Posts('assets/images/1.jpg', 1, 1),
    null,
    DateTime(2020, 02, 24, 7, 23, 26),
  ),
  NotificationData(
    User (
      'Ngọc Trinh',
      'assets/images/cover.jpg',
      'ngoctrinh'
    ),
    NotificationType.comment,
    Posts('assets/images/1.jpg', 1, 1),
    "This is a comment content. I don't know what is this",
    DateTime(2020, 02, 24, 6, 23, 26),
  ),
];