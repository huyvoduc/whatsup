import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/module/create_post/screen/comic/preview_comic_screen.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

import 'comic_home_bloc.dart';
import 'edit_comic_screen.dart';

class CommicScreen extends StatefulWidget {
  static Widget newInstance() {
    return BlocProvider<ComicHomeBloc>(
      creator: (_context, _bag) => ComicHomeBloc(),
      child: CommicScreen(),
    );
  }

  @override
  _CommicScreenState createState() => _CommicScreenState();
}

class _CommicScreenState extends BaseState<CommicScreen> {
  ComicHomeBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ComicHomeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  showSimpleDialog(
                      message: 'Bạn có muốn huỷ không?',
                      ok: () {
                        Navigator.pop(context);
                      });
                },
                behavior: HitTestBehavior.opaque,
                child: WText(
                  'Huỷ',
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              pushScreenOther(PreviewComicScreen(
                listComic: _bloc.listComic,
              ));
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              child: WText(
                'Tiếp',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<CommicModel>>(
        stream: _bloc.listComicStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();
          return ListView.separated(
              itemBuilder: (context, index) {
                if (index == snapshot.data.length) {
                  return _buildButton();
                }
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      _bloc.removeComic(index: index);
                    },
                    child: _buildItemComic(index));
              },
              separatorBuilder: (context, index) => Container(
                    height: 1,
                  ),
              itemCount: snapshot.data.length + 1);
        });
  }

  Widget _buildItemComic(int index) {
    if (_bloc.listComic[index].w == null) {
      _bloc.listComic[index].w = ModelWidgetComic();
      _bloc.listComic[index].w.w = Container(
          width: double.infinity,
          height: 350,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue[400]),
                child: Icon(
                  Icons.border_color,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              WText(
                'Chạm vào đây để sửa\nhoặc kéo sang trái để xoá',
                color: Colors.blue[400],
                textAlign: TextAlign.center,
              )
            ],
          ));
    }

    return Stack(children: <Widget>[
      _bloc.listComic[index].w.w,
      GestureDetector(
        onTap: () async {
          ModelWidgetComic _model = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditComicScreen(
                    renderW: !_bloc.listComic[index].isEdited
                        ? null
                        : _bloc.listComic[index].w)),
          );
          _bloc.listComic[index].w = _model;
          _bloc.listComic[index].isEdited = true;

          setState(() {});
        },
        child: Container(
          width: screenSize.width,
          height: 350,
          color: Colors.transparent,
        ),
      )
    ]);
  }

  Widget _buildButton() {
    return Container(
      height: 100,
      width: double.infinity,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _bloc.addComic();
              setState(() {});
            },
            child: Container(
              width: 65,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
