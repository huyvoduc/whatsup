import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsup/api/api.dart';
import 'package:whatsup/module/create_post/screen/meme/meme_web_model.dart';

class MemeSearchBloc implements Bloc {
  MemeWebModel _model = MemeWebModel();
  final BehaviorSubject<MemeWebModel> _listMemeModel = BehaviorSubject();
  ValueStream<MemeWebModel> get streamMeme => _listMemeModel.stream;

  @override
  void dispose() {
    _listMemeModel.close();
  }

  MemeSearchBloc() {
    getListMeme();
  }

  Future<void> searchMeme({String text =''}) async {
    _model = await api.searchMeMeWeb(text: text);
    _listMemeModel.add(_model);
  }

  Future<void> getListMeme({String type = 'new'}) async {
    _listMemeModel.addError(null);
    _model = await api.getListMeMeWeb(type: type);
    _listMemeModel.add(_model);
  }
}
