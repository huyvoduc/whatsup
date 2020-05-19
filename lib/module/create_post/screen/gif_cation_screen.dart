import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsup/common/constanst/package_constants.dart';
import 'package:whatsup/module/create_post/screen/upload_screen.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

import 'image/select_hashtag_screen.dart';

class GifCationScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final GlobalKey<ExtendedImageEditorState> editorKey;
  final String urlImage;
  final File fileImage;

  const GifCationScreen(
      {Key key, this.editorKey, this.urlImage, this.fileImage})
      : super(key: key);

  @override
  _GifCationScreenState createState() => _GifCationScreenState();
}

class _GifCationScreenState extends BaseState<GifCationScreen>
    with TickerProviderStateMixin {
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  GifController _animationCtrl;
  FocusNode _focusNodeCaption = FocusNode();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _focusNodeCaption.addListener(() {
      Future.delayed(Duration(milliseconds: 700), () {
        _scrollController.animateTo(_scrollController.position.extentAfter,
            duration: Duration(milliseconds: 300), curve: Curves.easeInSine);
      });
    });
    saveNetworkImageToPhoto(widget.urlImage);
    _animationCtrl =
        GifController(vsync: this, duration: Duration(milliseconds: _mili));
    super.initState();
  }

  void handleControllerGif() {
    _animationCtrl.repeat(
      min: 0,
      max: _countFrame.toDouble(),
      period: Duration(milliseconds: _mili),
    );
  }

  File _outFile;
  bool isDone = false;

  void statisticsCallback(int time, int size, double bitrate, double speed,
      int videoFrameNumber, double videoQuality, double videoFps) {
    _countFrame = videoFrameNumber;
    print(
        "Statistics: time: $time, size: $size, bitrate: $bitrate, speed: $speed, videoFrameNumber: $videoFrameNumber, videoQuality: $videoQuality, videoFps: $videoFps");
  }

  void saveNetworkImageToPhoto(String url, {bool useCache: true}) async {
    final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();
    final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
    var _pathOutFile = '';
    _flutterFFmpegConfig.enableStatisticsCallback(statisticsCallback);
    String dir = (await getApplicationDocumentsDirectory()).path;
    var ran = Random();
    var _name = ran.nextInt(1000000);
    File file;
    isDone = false;
    String fullPath;
    Uint8List data;
    if (widget.urlImage != null) {
      fullPath = '$dir/$_name.gif';

      data = await getNetworkImageData(url, useCache: useCache);
      file = File(fullPath);
      await file.writeAsBytes(data);
    } else {
      fullPath = widget.fileImage.path;

      file = widget.fileImage;
    }

    Rect _rect = widget.editorKey.currentState.getCropRect();

    if (_rect.top == 0 &&
        _rect.left == 0 &&
        (_rect.width == widget.editorKey.currentState.image.width.toDouble()) &&
        ((_rect.height ==
            widget.editorKey.currentState.image.height.toDouble()))) {
      _outFile = file;
      _pathOutFile = file.path;
    } else {
      await _flutterFFmpeg
          .execute(
              "-i $fullPath -filter:v \"crop=${_rect.width}:${_rect.height}:${_rect.left}:${_rect.top}\"  -c:a copy ${dir}/out_$_name.gif")
          .then((rc) => print('FFmpeg process exited with rc $rc'));
      _pathOutFile = '$dir/out_$_name.gif';

      _outFile = File(_pathOutFile);
      print('_pathOutFile: ${_pathOutFile}');
    }

    print('_pathOutFile: ${_pathOutFile}');

    await _flutterFFprobe.getMediaInformation(_pathOutFile).then((info) {
      print('-------');
      print(info);
      String _duration = info['duration'].toString();
      String averageFrame = info['streams'][0]['averageFrameRate'].toString();
      _mili = int.tryParse(_duration);
      print('_mili: ${_mili}');
      if (_countFrame == 0)
        _countFrame =
            (double.tryParse(averageFrame) * int.parse(_duration) / 1000)
                .round();
      print('_countFrame: ${_countFrame}');
    });
    isDone = true;
    handleControllerGif();
    setState(() {});
  }

  void commandOutputLogCallback(int level, String message) {
    _commandOutput += message;
    setState(() {});
  }

  String _commandOutput = '';

  int _mili = 0;

  int _countFrame = 0;

  Widget ret;

  saveFile() {
    saveNetworkImageToPhoto(widget.urlImage);
  }

  @override
  void dispose() {
    print('_GifCationScreenState.dispose');
    _animationCtrl.stop();
    _animationCtrl.dispose();
    GifImage.cache.clear();
    _outFile = null;
    super.dispose();
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
                  child: const WText(
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
                      if (isDone) {
                        pushScreenOther(UpLoadSreen(
                          imageAfterCrop: _outFile,
                          captionTop: text,
                          caption: caption,
                          type: 'SingleGIF',
                          tags: orginalListHashTag,
                        ));
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: WText(
                      'Đăng',
                      color: isDone ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
          ]),
      body: _buildBody(),
    );
  }

  String text = '';

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      color: text.isNotEmpty
                          ? Colors.white
                          : Colors.lightBlueAccent,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                            color:
                                text.isNotEmpty ? Colors.black : Colors.white,
                            fontSize: 24),
                        onChanged: (data) {
                          text = data;
                          if (text.length <= 1) {
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15.0),
                            border: InputBorder.none,
                            hintText: 'tap to edit the caption',
                            hintStyle: TextStyle(
                              color:
                                  text.isNotEmpty ? Colors.black : Colors.white,
                              fontSize: 24,
                            )),
                      )),
                  !isDone
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: GifImage(
                            image: FileImage(_outFile),
                            controller: _animationCtrl,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          )),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 16),
                    color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          keyboardType: TextInputType.multiline,
                          onChanged: (data) {
                            caption = data;
                          },
                          maxLines: null,
                          focusNode: _focusNodeCaption,
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
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            color: const Color.fromRGBO(35, 35, 39, 1),
            height: 50,
            child: Container(
              width: scaleWidth(150),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.fast_rewind,
                      color: Colors.white,
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context)
                          .copyWith(thumbShape: const RoundSliderThumbShape()),
                      child: Slider(
                        value: speed / 2,
                        onChanged: (newValue) {
                          if (newValue != 0) {
                            speed = newValue * 2;
                            print('speed: ${speed}');
                            _animationCtrl.repeat(
                              min: 0,
                              max: _countFrame.toDouble(),
                              period: Duration(
                                  milliseconds: (_mili / speed).toInt()),
                            );
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    Icon(
                      Icons.fast_forward,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  String caption;

  List<String> orginalListHashTag = List();

  String listHashTags = '# thêm hashtags';
  double speed = 1;
}
