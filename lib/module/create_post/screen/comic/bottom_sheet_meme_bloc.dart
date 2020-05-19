import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsup/api/api.dart';

import 'model/album_model.dart';

class BottomSheetStickerBloc implements Bloc {
  BehaviorSubject<List<dynamic>> _listStickerContoller = BehaviorSubject();

  ValueStream<List<dynamic>> get listSticker => _listStickerContoller.stream;

  List<dynamic> _listSticker = List();

  List<AlbumModel> listAlbum = List();

  BottomSheetStickerBloc() {
    getdata();
  }

  void getdata() async {
    await getListAlbum();
    getListSticker();
  }

  Future<void> getListAlbum() async {
    listAlbum = await Api().getAlbumListComic();
  }

  void getListSticker() async {
    _listSticker = await Api().getListSticker(type: listAlbum[albumActive].type);
    _listStickerContoller.add(_listSticker);
  }

  void onUserSelectAlbum({int index}) {
    _listStickerContoller.add(List());

    // ignore: use_setters_to_change_properties
    albumActive = index;
    getListSticker();
  }

  int albumActive = 0;

  @override
  void dispose() {
    _listStickerContoller.close();
    // TODO: implement dispose
  }
}
