import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsup/model/post_model.dart';

import '../model/user_model.dart';

enum WhatsUpDBCollection { users, media, posts, tags }

extension WhatsupDBCollectionExtension on WhatsUpDBCollection {
  String get value {
    return toString().replaceAll("WhatsUpDBCollection.", "");
  }
}

class WhatsUpDBService extends BaseDataBaseService {
  static final WhatsUpDBService instance = WhatsUpDBService();

  Future<Map<String, dynamic>> getUserInfo(String id) async {
    final data = await _getData(colection: WhatsUpDBCollection.users, path: id);
    return data.data;
  }

  Future<bool> checkUserNameExist(String userName) async {
    final usersRef = await _getCollection(colection: WhatsUpDBCollection.users);
    final data =
        await usersRef.where('username', isEqualTo: userName).getDocuments();
    return data.documents.isNotEmpty;
  }

  Future<bool> checkPhoneExist(String phone) async {
    final usersRef = await _getCollection(colection: WhatsUpDBCollection.users);
    final data =
    await usersRef.where('phone_number', isEqualTo: phone).getDocuments();
    return data.documents.isNotEmpty;
  }

  Future updateUser(UserModel user) async {
    await _createOrUpdateData(
        collection: WhatsUpDBCollection.users,
        data: user.toJson(),
        path: user.id);
  }

  Future getCollection(WhatsUpDBCollection name)async{
   return  _getCollection(colection: name);
  }

  Future<List> getListTags() async {
    final data = await _getData2(colection: WhatsUpDBCollection.tags);
    return data.documents;
  }

  Future<void> doLike(PostModel post, String pathLike, data) async {
   await _doLike(collection: WhatsUpDBCollection.posts,path: pathLike, data:data);
  }


}

class BaseDataBaseService {
  /// lấy data về tại 1 collection va path cụ thể
  /// nếu lấy nguyên collection thì để path null nha
  Future<DocumentSnapshot> _getData(
      {@required WhatsUpDBCollection colection, String path}) async {
    final data = await Firestore.instance
        .collection(colection.value)
        .document(path)
        .get();
    return data;
  }
  Future<QuerySnapshot> _getData2(
      {@required WhatsUpDBCollection colection, String path}) async {
    final data = await Firestore.instance
        .collection(colection.value).getDocuments();
    return data;
  }
  /// tạo hay update 1 path nào đó đều dùng hàm này nha
  /// collection : là collection mún update
  /// data : là 1 Map chứa data cần update
  /// path : là path muốn update nằm trong collection bên trên , ví dụ : "path"
  /// hoặc "path_1/path_2"
  Future<void> _createOrUpdateData(
      {@required WhatsUpDBCollection collection,
      @required Map data,
      String path}) async {
    await Firestore.instance
        .collection(collection.value)
        .document(path)
        .setData(data);
  }

  /// trả về collection
  Future<CollectionReference> _getCollection({
    @required WhatsUpDBCollection colection,
  }) async {
    return Firestore.instance.collection(colection.value);
  }

  Future<void> _doLike({@required WhatsUpDBCollection collection,
    Map data,
    String path}) async {
    await Firestore.instance
        .collection(collection.value)
        .document(path).setData(data);
  }
}
