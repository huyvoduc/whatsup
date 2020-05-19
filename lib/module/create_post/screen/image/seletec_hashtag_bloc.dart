import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsup/utils/firebase_database_service.dart';

class SelectHashTagBloc implements Bloc {
  final BehaviorSubject<List<String>> _hashTagContoller = BehaviorSubject();

  Stream<List<String>> get tagStream => _hashTagContoller.stream;

  final BehaviorSubject<List<HashTagModel>> _listHashTagSortController =
      BehaviorSubject();

  Stream<List<HashTagModel>> get listTagSortStream =>
      _listHashTagSortController.stream;

  List<HashTagModel> _listHashTagSortModel = List();


  SelectHashTagBloc(List<String> orginalListHashTag) {
    getListTag();
  }

  List<String> getTagsChoossed() {
    return _listTagsChoosed;
  }

  List<String> _listTagsChoosed = List();

  Future<void> getListTag() async {
    List<DocumentSnapshot> data = await WhatsUpDBService.instance.getListTags();
    for (int i = 0; i < data.length; i++) {
      _listHashTagSortModel.add(HashTagModel(
          name: data[i].documentID, count: data[i].data['post_count']));
    }
    _listHashTagSortController.add(_listHashTagSortModel);

  }

  void removeHashTags(int index) {
    _listTagsChoosed.removeAt(index);
    _hashTagContoller.add(_listTagsChoosed);
  }

  void onUserChangeText(String text) {
    List<HashTagModel> _temp = List();
    for (var i = 0; i < _listHashTagSortModel.length; i++) {
      if (_listHashTagSortModel[i].name.contains(text)) {
        _temp.add(_listHashTagSortModel[i]);
      }
    }
    _listHashTagSortController.add(_temp);
  }

  void onUserEnter(String data) {
    _listTagsChoosed.add(data);
    _hashTagContoller.add(_listTagsChoosed);
  }

  void dispose() {
    _listHashTagSortController.close();
    _hashTagContoller.close();
  }
}

class HashTagModel {
  String name;
  int count;

  HashTagModel({this.name, this.count});
}
