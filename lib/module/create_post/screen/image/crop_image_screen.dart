import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/module/create_post/screen/meme/add_caption_meme.dart';
import 'package:whatsup/utils/crop_image_utils/extented_image_editor.dart';
import 'package:whatsup/utils/crop_image_utils/isolate_crop.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

import 'add_text_image_screen.dart';

class AspectRatioItem {
  final String text;
  final double value;

  AspectRatioItem({this.value, this.text});
}

class CropImageScreen extends StatefulWidget {
  final File fileImage;
  final String url;
  final bool isMeme;
  final bool isCommic;
  final bool isMutilsup;

  const CropImageScreen(
      {Key key,
      this.fileImage,
      this.url,
      this.isMeme = false,
      this.isCommic = false, this.isMutilsup=false})
      : super(key: key);

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends BaseState<CropImageScreen> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final List<AspectRatioItem> _aspectRatios = List<AspectRatioItem>()
    ..add(AspectRatioItem(text: 'custom', value: CropAspectRatios.custom))
    ..add(AspectRatioItem(text: 'original', value: CropAspectRatios.original))
    ..add(AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1))
    ..add(AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3))
    ..add(AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4))
    ..add(AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9))
    ..add(AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16));
  AspectRatioItem _aspectRatio;
  bool _cropping = false;
  File fileAfterCrop;

  @override
  void initState() {
    _aspectRatio = _aspectRatios.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fileImage == null && widget.url == null) Navigator.pop(context);
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
                        if(!isFail)
                        _cropImage(false);
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
        body: isFail
            ? const Center(
                child: WText('Có lỗi sảy ra trong quá trình tải ảnh.'))
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
                          initCropRectType: InitCropRectType.imageRect,
                          cropAspectRatio: _aspectRatio.value);
                    },
                  )
                : ExtendedImage.network(
                    widget.url,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    enableLoadState: true,
                    loadFaild: () {
                      Future.delayed(Duration(milliseconds: 300),(){
                        isFail = true;
                        setState(() {});
                      });
                    },
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (state) {
                      return EditorConfig(
                          maxScale: 8.0,
                          cropRectPadding: const EdgeInsets.all(20.0),
                          hitTestSize: 20.0,
                          initCropRectType: InitCropRectType.imageRect,
                          cropAspectRatio: _aspectRatio.value);
                    },
                  ));
  }

  bool isFail = false;

  void _cropImage(bool useNative) async {
    showLoading();
    if (_cropping) return;
    var msg = "";
    try {
      _cropping = true;

      fileAfterCrop =
          await cropImageDataWithDartLibrary(state: editorKey.currentState);
    } catch (e, stack) {
      msg = "save faild: $e\n $stack";
      debugPrint(msg);
    }
    _cropping = false;
    Navigator.pop(context);
    if (widget.isMeme) {
      pushScreenOther(AddCaptionMeMeScreen(
        imageAfterCrop: fileAfterCrop,
      ));
    } else if (widget.isCommic) {
      Navigator.pop(context, fileAfterCrop);
    } else if(widget.isMutilsup){
      Navigator.pop(context, fileAfterCrop);
    }else
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddTextImageScreen(
                  imageAfterCrop: fileAfterCrop,
                )),
      );
  }
}
