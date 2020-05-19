import 'package:whatsup/module/profile/models/user.dart';

enum ObservableType {
  like,
  visit,
}

class ObservableHistory {
  DateTime date;
  List<User> users;
  ObservableType type;

  ObservableHistory(this.date, this.users, this.type);
}