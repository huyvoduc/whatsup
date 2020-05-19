import 'package:whatsup/module/profile/models/posts.dart';
import 'package:whatsup/module/profile/models/user.dart';

class CommentHistory {
  String message;
  User user;
  Posts posts;
  String image;
  DateTime datetime;

  CommentHistory(
    this.message,
    this.user,
    this.posts,
    this.image,
    this.datetime,
  );
}