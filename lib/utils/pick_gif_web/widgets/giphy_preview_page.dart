import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:whatsup/module/create_post/screen/gif_cation_screen.dart';
import 'package:whatsup/module/create_post/screen/image/crop_image_screen.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';

class GiphyPreviewPage extends StatefulWidget {
  final String url;
  final Widget title;
  final File fileImage;
  final ValueChanged<GiphyGif> onSelected;

  const GiphyPreviewPage(
      {Key key, this.url, this.title, this.onSelected, this.fileImage})
      : super(key: key);

  @override
  _GiphyPreviewPageState createState() => _GiphyPreviewPageState();
}

class _GiphyPreviewPageState extends BaseState<GiphyPreviewPage> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final List<AspectRatioItem> _aspectRatios = List<AspectRatioItem>()
    ..add(AspectRatioItem(text: "custom", value: CropAspectRatios.custom))
    ..add(AspectRatioItem(text: "original", value: CropAspectRatios.original))
    ..add(AspectRatioItem(text: "1*1", value: CropAspectRatios.ratio1_1))
    ..add(AspectRatioItem(text: "4*3", value: CropAspectRatios.ratio4_3))
    ..add(AspectRatioItem(text: "3*4", value: CropAspectRatios.ratio3_4))
    ..add(AspectRatioItem(text: "16*9", value: CropAspectRatios.ratio16_9))
    ..add(AspectRatioItem(text: "9*16", value: CropAspectRatios.ratio9_16));
  AspectRatioItem _aspectRatio;

  @override
  void initState() {
    _aspectRatio = _aspectRatios.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const WText('crop'),
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
                    child: WText(
                      'cancel',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            actions: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        if (!isFail)
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => GifCationScreen(
                              urlImage: widget.url,
                              fileImage: widget.fileImage ?? null,
                              editorKey: editorKey,
                            ),
                          ));
                      },
                      behavior: HitTestBehavior.opaque,
                      child: WText(
                        'next',
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
            ]),
        body: SafeArea(
            bottom: false,
            child: Container(
              color: Colors.black,
              child: Center(
                  child: isFail
                      ? WText("Có lỗi sảy ra trong quá trình tải ảnh.")
                      : widget.fileImage != null
                          ? ExtendedImage.file(
                              widget.fileImage,
                              fit: BoxFit.contain,
                              mode: ExtendedImageMode.editor,
                              enableLoadState: true,
                              extendedImageEditorKey: editorKey,
                              initEditorConfigHandler: (state) {
                                return EditorConfig(
                                    maxScale: 8.0,
                                    cropRectPadding: const EdgeInsets.all(20.0),
                                    hitTestSize: 20.0,
                                    cornerColor: Colors.blueAccent,
                                    initCropRectType:
                                        InitCropRectType.imageRect,
                                    cropAspectRatio: _aspectRatio.value);
                              },
                            )
                          : ExtendedImage.network(
                              widget.url,
                              fit: BoxFit.contain,
                              mode: ExtendedImageMode.editor,
                              enableLoadState: true,
                              loadFaild: () {
                                isFail = true;
                                setState(() {});
                              },
                              extendedImageEditorKey: editorKey,
                              initEditorConfigHandler: (state) {
                                return EditorConfig(
                                    maxScale: 8.0,
                                    cropRectPadding: const EdgeInsets.all(20.0),
                                    hitTestSize: 20.0,
                                    cornerColor: Colors.blueAccent,
                                    initCropRectType:
                                        InitCropRectType.imageRect,
                                    cropAspectRatio: _aspectRatio.value);
                              },
                            )),
            )));
  }

  bool isFail = false;

//  void _getImage() async {
//    _memoryImage = await pickImage();
//    setState(() {
//      editorKey.currentState.reset();
//    });
//  }

}
