import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/common/constanst/package_constants.dart';
import 'package:whatsup/module/create_post/screen/image/select_hashtag_screen.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';
import 'package:dio/dio.dart';
import '../upload_screen.dart';

class PreviewVideoScreen extends StatefulWidget {
  final String url;
  final File fileVideo;

  const PreviewVideoScreen({Key key, this.fileVideo, this.url})
      : super(key: key);

  @override
  _PreviewVideoScreenState createState() => _PreviewVideoScreenState();
}

class _PreviewVideoScreenState extends BaseState<PreviewVideoScreen> {
  VideoPlayerController _controller;
  bool _isDone = false;
  var httpClient = new HttpClient();
  final FlutterFFprobe _flutterFFprobe = FlutterFFprobe();
  String textError;

  @override
  void initState() {
    if (widget.url != null) {
      _downloadFile(widget.url, 'testvideo', null);
    } else {
      _downloadFile(null, 'testvideo', widget.fileVideo);
    }
    super.initState();
  }

  File _fileVideo;
  int _count = 0, _total = 1;

  Future<File> _downloadFile(
      String url, String filename, File fileVideo) async {
    File file;
    if (url != null) {
//      var request = await httpClient.getUrl(Uri.parse(url));
      String dir = (await getApplicationDocumentsDirectory()).path;

      Response response = await Dio().download(url, '$dir/$filename.mp4',
          onReceiveProgress: (count, total) {
        _count = count;

        _total = total;
        setState(() {});
      });

      file = File('$dir/$filename.mp4');
    } else {
      file = fileVideo;
    }
    String duration;
    await _flutterFFprobe.getMediaInformation(file.path).then((info) {
      duration = (info['duration'] ?? 0).toString();
    });

    if (duration == '0') {
      isError = true;
      await showSimpleDialog(
          message: 'Có lỗi sảy ra khi tải video. Vui lòng thử video khác.',
          ok: () {
            Navigator.pop(context);
          });
      textError = 'Có lỗi sảy ra khi tải xuống.';
    } else {
      if (int.tryParse(duration) > 120000) {
        await showSimpleDialog(
            message:
                'Độ dài của video vượt quá 2 phút. Vui lòng thử video khác.',
            ok: () {
              Navigator.pop(context);
            });
      } else {
        _controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            _fileVideo = file;
            _playVideo();
          });
//
        _isDone = true;
      }
    }
    setState(() {});

    return file;
  }

  bool isError = false;

  @override
  void onFirstFrame() {
    super.onFirstFrame();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: const WText(
            'Xuất bản',
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          leading: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                    onTap: () {
                      if (_controller != null) {
                        _controller.setVolume(0.0);
                        _controller.pause();
                      }
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
                if (_isDone)
                  pushScreenOther(UpLoadSreen(
                    type: 'SingleVideo',
                    caption: caption,
                    imageAfterCrop: _fileVideo,
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
        body: Center(
          child: isError
              ? WText(textError)
              : !_isDone
                  ? Container(
                      width: 200,
                      height: 3,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withOpacity(0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        value: _count / _total,
                      ),
                    )
                  : _previewVideo(),
        ),
      ),
    );
  }

  Widget _previewVideo() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: AspectRatioVideo(_controller)),
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
                if (_controller != null) {
                  _controller.setVolume(0.0);
                  _controller.pause();
                }
                await pushScreenOther(SelectHashTag.newInstance(
                    callBackSave: (data) {
                      if (data.length > 0) {
                        orginalListHashTag = data;
                        listHashTags = data.join('  #');
                        setState(() {});
                      }
                    },
                    orginalListHashTag: orginalListHashTag));
                if (_controller != null) {
                  _controller.setVolume(1.0);
                  _controller.play();
                }
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

  String caption;

  List<String> orginalListHashTag = List();

  String listHashTags = '# thêm hashtags';

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void onPause() {
    print('_PreviewVideoScreenState.deactivate');
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.pause();
    }
    super.onPause();
  }

  @override
  void onResume() {
    print('_PreviewVideoScreenState.onResume');
    if (_controller != null) {
      _controller.setVolume(1.0);
      _controller.play();
    }
    print('_PreviewVideoScreenState.onResume');
    super.onResume();
  }

  @override
  void dispose() {
    print('_PreviewVideoScreenState.dispose');
    _disposeVideoController();
    super.dispose();
  }

  Future<void> _playVideo() async {
//    print('_PreviewVideoScreenState._playVideo');
    await _controller.setVolume(1.0);

    Future.delayed(const Duration(milliseconds: 400), () async{
          await _controller.play();
    });

    await _controller.initialize();
    await _controller.setLooping(true);
    setState(() {});
  }

  Future<void> _disposeVideoController() async {
    if (_controller != null) {
      await _controller.dispose();
      _controller = null;
    }
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
