import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsup/common/constanst/package_constants.dart';
import 'package:whatsup/module/create_post/screen/image/select_hashtag_screen.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';
import 'dart:ui' as ui;
import '../upload_screen.dart';
import 'comic_home_bloc.dart';

class PreviewComicScreen extends StatefulWidget {
  final List<CommicModel> listComic;

  const PreviewComicScreen({Key key, this.listComic}) : super(key: key);

  @override
  _PreviewComicScreenState createState() => _PreviewComicScreenState();
}

class _PreviewComicScreenState extends BaseState<PreviewComicScreen> {
  GlobalKey _keyList = new GlobalKey();
  File fileImage;

  Future<File> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _keyList.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);

      String dir = (await getApplicationDocumentsDirectory()).path;
      String fullPath = '$dir/comic.png';

      fileImage = await File(fullPath).writeAsBytes(pngBytes);
      print('fullPath: $fullPath');
      return fileImage;
    } catch (e) {
      print(e);
    }
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            )),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              _isLoading = true;
              setState(() {});
              await _capturePng();
              _isLoading = false;
              setState(() {});

              pushScreenOther(UpLoadSreen(
                imageAfterCrop: fileImage,
                type: 'SingleImage',
                caption: caption,
                tags: orginalListHashTag,
              ));
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              child: WText(
                'Đăng',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        _buildBody(),
        !_isLoading
            ? const SizedBox()
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black38,
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
      ]),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: SingleChildScrollView(
            child: RepaintBoundary(
              key: _keyList,
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Stack(children: <Widget>[
                      widget.listComic[index].w.w,
                      GestureDetector(
                        onTap: () async {
                          print('nhay vao day');
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Container(
                          width: screenSize.width,
                          height: 350,
                          color: Colors.transparent,
                        ),
                      )
                    ]);
                  },
                  separatorBuilder: (context, index) => Container(
                      ),
                  itemCount: widget.listComic.length),
            ),
          ),
        ),
        otherWidget()
      ],
    );
  }

  Widget otherWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              keyboardType: TextInputType.multiline,
              onChanged: (data) {
                caption = data;
              },
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 15.0),
                  border: InputBorder.none,
                  hintText: 'Viết mô tả...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: 'AvenirLTStd',
                    color: Colors.white,
                    package: PackageConstants.package,
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              color: Colors.grey[300].withOpacity(0.2),
              height: 1,
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () async {
                pushScreenOther(SelectHashTag.newInstance(
                    callBackSave: (data) {
                      if (data.length > 0) {
                        orginalListHashTag = data;
                        listHashTags = data.join('  #');
                        setState(() {});
                      }
                    },
                    orginalListHashTag: orginalListHashTag));
              },
              child: Container(
                  margin: const EdgeInsets.only(left: 15.0),
                  child: WText(
                    '#${listHashTags.toString()}',
                    color: Colors.white,
                    size: 16,
                  )),
            )
          ],
        ),
      ),
    );
  }

  String text;
  String caption;

  List<String> orginalListHashTag = List();

  String listHashTags = '# thêm hashtags';
}
