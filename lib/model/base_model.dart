import 'user_model.dart';

const String colId = 'id';

class BaseModel {
  String id;
  String error;
  UserModel createdBy;
  DateTime createdAt;

  BaseModel({this.id, this.error, this.createdBy, this.createdAt});
}
