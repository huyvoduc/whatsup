import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'edit_comic_screen.dart';

class ComicHomeBloc implements Bloc {
  final BehaviorSubject<List<CommicModel>> _listComicController =
      BehaviorSubject();

  Stream<List<CommicModel>> get listComicStream => _listComicController.stream;

  List<CommicModel> listComic = List();

  ComicHomeBloc() {
    listComic.add(CommicModel());
    _listComicController.add(listComic);
  }

  void addComic() {
    listComic.add(CommicModel());
    _listComicController.add(listComic);
  }

  void removeComic({int index}) {
    listComic.removeAt(index);
    _listComicController.add(listComic);
  }

  @override
  void dispose() {
    _listComicController.close();
  }
}

class CommicModel {

  ModelWidgetComic w;
  bool isEdited = false;
  CommicModel({this.w});
}
