import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/module/create_post/screen/comic/bottom_sheet_meme_bloc.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

import 'model/album_model.dart';

class BottomSheetSticker extends StatefulWidget {
  static Widget newInstance() {
    return BlocProvider<BottomSheetStickerBloc>(
      creator: (_context, _bag) => BottomSheetStickerBloc(),
      child: BottomSheetSticker(),
    );
  }

  @override
  _BottomSheetStickerState createState() => _BottomSheetStickerState();
}

class _BottomSheetStickerState extends BaseState<BottomSheetSticker> {
  BottomSheetStickerBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<BottomSheetStickerBloc>(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 12,
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isShowAblum
                    ? const WText('Chọn Album')
                    : Container(child: WText('Chọn Sticker'))),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isShowAblum
                        ? Container(child: _buildListAlbum())
                        : _buildSticker()))
          ],
        ),
      ),
    );
  }

  bool _isShowAblum = false;

  Widget _buildSticker() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: StreamBuilder<List<dynamic>>(
          stream: _bloc.listSticker,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return CupertinoActivityIndicator();
            if (snapshot.data.length == 0) return CupertinoActivityIndicator();

            return Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _isShowAblum = true;
                    setState(() {});
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 12,
                      ),
                      WText(
                        _bloc.listAlbum[_bloc.albumActive].name,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      if (index % 3 == 1 || index % 3 == 2) {
                        return const SizedBox();
                      }
                      return Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                  context, snapshot.data[index].toString());
                            },
                            child: Image.network(
                              snapshot.data[index].toString(),
                              width: screenSize.width / 3,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          index + 1 >= snapshot.data.length
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,
                                        snapshot.data[index + 1].toString());
                                  },
                                  child: Image.network(
                                    snapshot.data[index + 1].toString(),
                                    width: screenSize.width / 3,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                          index + 2 >= snapshot.data.length
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,
                                        snapshot.data[index + 2].toString());
                                  },
                                  child: Image.network(
                                    snapshot.data[index + 2].toString(),
                                    width: screenSize.width / 3,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                        ],
                      );
                    },
                    itemCount: snapshot.data.length,
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildListAlbum() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.black,
      child: ListView.separated(
        separatorBuilder: (_, __) => Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey.withOpacity(0.4),
        ),
        itemCount: _bloc.listAlbum.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _indexChooseAlbum = index;
              _bloc.onUserSelectAlbum(index: index);
              _isShowAblum = false;
              setState(() {});
            },
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 8,
                ),
                Image.network(
                  _bloc.listAlbum[index].thumbnail,
                  width: 40,
                  height: 40,
                ),
                WText(
                  _bloc.listAlbum[index].name,
                  color: Colors.white,
                ),
                Expanded(
                  child: Container(),
                ),
                _indexChooseAlbum != index
                    ? const SizedBox()
                    : Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  int _indexChooseAlbum = 0;
}
