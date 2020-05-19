import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:whatsup/module/create_post/screen/image/crop_image_screen.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class EditMutilsSupScreen extends StatefulWidget {
  @override
  _EditMutilsSupScreenState createState() => _EditMutilsSupScreenState();
}

class _EditMutilsSupScreenState extends BaseState<EditMutilsSupScreen> {
  List<AssetEntity> picked = [];
  List<FileModel> _listFile = List();
  final List<Color> _listColor = List();
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listColor.add(Colors.white);
    _listColor.add(Colors.black);
    _listColor.add(Colors.green);
    _listColor.add(Colors.red);
    _listColor.add(Colors.yellow);
    _listColor.add(Colors.blue);
    _listColor.add(Colors.orange);
    _listColor.add(Colors.grey);
    _listColor.add(Colors.purpleAccent);
    _listColor.add(Colors.tealAccent);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void onFirstFrame() {
    _pickAsset(multi: true);
    super.onFirstFrame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(),
    );
  }

  void _pickAsset({bool multi = true}) async {
    final result = await PhotoPicker.pickAsset(
      context: context,
      pickType: PickType.onlyImage,
      pickedAssetList: multi ? picked : null,
      maxSelected: multi ? 10 : 1,
      isAnimated: false,
    );
    if (result != null && result.isNotEmpty) {
      print('picked: ${picked.length}');
      print('result: ${result.length}');
      _indexActive = 0;
      picked = result;
      for (int i = 0; i < picked.length; i++) {
        bool isCompare = false;
        for (int j = 0; j < _listFile.length; j++) {
          if (_listFile[j].id == picked[i].id) {
            isCompare = true;
            break;
          }
        }
        if (!isCompare)
          _listFile
              .add(FileModel(file: await picked[i].file, id: picked[i].id));
      }
      if (_indexActive == -1) _indexActive = 0;
      _isLoading = false;
      setState(() {});
    }
  }

  bool _isLoading = true;
  int _indexActive = 0;
  bool _isShowSpeed = false;
  bool _isNext = true;
  bool _isShowToolText = false;
  GlobalKey _keyList = new GlobalKey();

  _buildBody() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          RepaintBoundary(
            key: _keyList,
            child: Stack(
              children: <Widget>[
                _buildBackGround(),
                _buildStackText(),
              ],
            ),
          ),
          _isShowSpeed
              ? _buildSpeed()
              : _isShowStackMedia ? _buildStackMedia() : SizedBox(),
          _buildToolsEdit(),
          _buildCheck(),
          _buildToolText(),
          !_isShowToolText ? const SizedBox() : _buildWidgetText(),
          _buildRemove(),
          _isShowToolText ? const SizedBox() : _buildSave(),
        ],
      ),
    );
  }

  Future<File> _capturePng() async {
    try {
      showLoading();

      print('inside');
      RenderRepaintBoundary boundary =
          _keyList.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      final result =
          await ImageGallerySaver.saveImage(pngBytes);
      hideLoading();
      print(result);

    } catch (e) {
      print(e);
    }
  }

  _buildSave() {
    return Positioned(
      left: 16,
      bottom: 10,
      child: GestureDetector(
        onTap: () {
          _capturePng();
        },
        child: Column(children: <Widget>[
          ClipRect(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 2.0,
                  left: 2.0,
                  child: Icon(
                    Icons.save_alt,
                    color: Colors.black.withOpacity(0.5),
                    size: 24,
                  ),
                ),
                BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Icon(
                    Icons.save_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          ShadowText(
            'Lưu',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ]),
      ),
    );
  }

  _buildCheck() {
    if (_isShowSpeed) {
      return Positioned(
          bottom: 90,
          right: 10,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isShowSpeed = false;
              });
            },
            child: Icon(
              Icons.check_circle,
              color: Colors.blue,
              size: 30,
            ),
          ));
    }
    return SizedBox();
  }

  _buildSpeed() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 4,
          ),
          const WText(
            '0:01',
            color: Colors.white,
            size: 12,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context)
                  .copyWith(thumbShape: const RoundSliderThumbShape()),
              child: Slider(
                activeColor: Colors.yellow[700],
                // ignore: prefer_interpolation_to_compose_strings
                label: _listFile[_indexActive].speed.toString() + 's',
                divisions: 15,
                inactiveColor: Colors.grey.withOpacity(0.3),
                value: _listFile[_indexActive].speed / 15,
                onChanged: (newValue) {
                  _listFile[_indexActive].speed = (newValue * 15).round();
                  if (_listFile[_indexActive].speed == 0) {
                    _listFile[_indexActive].speed = 1;
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          const WText(
            '0:15',
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
    );
  }

  _onUserAddText() {
    _isShowToolText = true;
    _isShowSpeed = false;
    _isShowStackMedia = false;
    setState(() {});
  }

  bool _isCancelPlay = false;
  Timer _timer;
  bool _isDonePlay = false;

  Future<dynamic> startTimer() async {
    setState(() {
      _isDonePlay = true;
      _isPlay = true;
    });
    _timer =
        await Timer(Duration(seconds: _listFile[_indexActive].speed), () async {
      if (_isCancelPlay) return;
      if (_listFile[_indexActive].isNext) {
        if (_indexActive < _listFile.length - 1) {
          _indexActive = _indexActive + 1;
          _isPlay = false;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 100));
          startTimer();
        } else {
          _isDonePlay = false;
          _isPlay = false;
        }
      } else {
        ///loop
        _isPlay = false;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 100));
        startTimer();
      }

      setState(() {});
    });
  }

  _buildToolsEdit() {
    // ignore: always_put_control_body_on_new_line
    if (_listFile.isEmpty) return const SizedBox();
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).padding.top + 56,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _onUserAddText();
            },
            child: ShadowText(
              'Aa',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () async {
              final _imageCrop = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CropImageScreen(
                          fileImage: _listFile[_indexActive].file,
                          url: null,
                          isMutilsup: true,
                        )),
              );
              if (_imageCrop != null) {
                _listFile[_indexActive].file = _imageCrop;
              }
            },
            child: ClipRect(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 2.0,
                    left: 2.0,
                    child: Icon(
                      Icons.crop,
                      color: Colors.black.withOpacity(0.5),
                      size: 26,
                    ),
                  ),
                  BackdropFilter(
                    filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Icon(
                      Icons.crop,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isShowSpeed = true;
              });
            },
            child: ClipRect(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 2.0,
                    left: 2.0,
                    child: Icon(
                      Icons.access_time,
                      color: Colors.black.withOpacity(0.5),
                      size: 26,
                    ),
                  ),
                  BackdropFilter(
                    filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              _listFile[_indexActive].isNext = !_listFile[_indexActive].isNext;
              _isDonePlay = false;
              _timer.cancel();
              _isCancelPlay = true;
              _isPlay = false;
              setState(() {});
            },
            child: ClipRect(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 2.0,
                    left: 2.0,
                    child: Icon(
                      _listFile[_indexActive].isNext
                          ? Icons.skip_next
                          : Icons.loop,
                      color: Colors.black.withOpacity(0.5),
                      size: 26,
                    ),
                  ),
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Icon(
                      _listFile[_indexActive].isNext
                          ? Icons.skip_next
                          : Icons.loop,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ShadowText(
            _listFile[_indexActive].isNext ? 'Next' : 'Loop',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              if (!_isPlay) {
                startTimer();
                _isCancelPlay = false;
              } else {
                _isDonePlay = false;
                _timer.cancel();
                setState(() {
                  _isCancelPlay = true;
                  _isPlay = false;
                });
              }
            },
            child: ClipRect(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 2.0,
                    left: 2.0,
                    child: Icon(
                      _isDonePlay
                          ? Icons.pause
                          : !_isPlay ? Icons.play_arrow : Icons.pause,
                      color: Colors.black.withOpacity(0.5),
                      size: 26,
                    ),
                  ),
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Icon(
                      _isDonePlay
                          ? Icons.pause
                          : !_isPlay ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ShadowText(
            _isDonePlay ? 'Pause' : !_isPlay ? 'Play' : 'Pause',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isShowStackMedia = !_isShowStackMedia;
              });
            },
            child: ClipRect(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 2.0,
                    left: 2.0,
                    child: Icon(
                      _isShowStackMedia ? Icons.grid_on : Icons.grid_off,
                      color: Colors.black.withOpacity(0.5),
                      size: 26,
                    ),
                  ),
                  BackdropFilter(
                    filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Icon(
                      _isShowStackMedia ? Icons.grid_on : Icons.grid_off,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ShadowText(
            _isShowStackMedia ? 'Show' : 'Hide',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  bool _isShowStackMedia = true;

  _buildBackGround() {
    if (_listFile.isEmpty) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await _pickAsset();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    if (_isLoading) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    return Stack(
      children: <Widget>[
        Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(
              _listFile[_indexActive].file,
              width: 100,
              fit: BoxFit.fitWidth,
            )),
      ],
    );
  }

  bool _isShowRemove = false;
  bool _isEditText = false;

  Widget _buildStackText() {
    List<Widget> _list = List();
    if (_listFile.length == 0) return SizedBox();
    for (var i = 0; i < _listFile[_indexActive].listText.length; i++) {
      var t = _listFile[_indexActive].listText[i];
      var _wText = FittedBox(
        fit: BoxFit.scaleDown,
        child: GestureDetector(
          onTap: () {
            _isEditText = true;
            _textEditingController.text = t.text;
            _listFile[_indexActive].listText.removeAt(i);
            _onUserAddText();
          },
          child: Container(
            width: screenSize.width,
            color: Colors.black45,
            alignment: Alignment.center,
            padding: EdgeInsets.all(4),
            child: Text(
              t.type == 1 ? t.text.toUpperCase() : t.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: t.type == 0 ? 14 : t.type == 1 ? 20 : 30,
                color: t.color,
                fontWeight: t.type == 2 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
      _list.add(Positioned(
//        left: t.left,
        top: t.top,
        child: Draggable(
          data: 'text-$i',
          childWhenDragging: Container(),
          onDragStarted: () {
            _isShowRemove = true;
            setState(() {});
          },
          onDraggableCanceled: (_, Offset offset) {
            _isShowRemove = false;
//            t.left = offset.dx;
            t.top = offset.dy - MediaQuery.of(context).padding.top + 20;
            setState(() {});
          },
          feedback: _wText,
          child: GestureDetector(
              onTap: () {
                _textEditingController.text = t.text;
                FocusScope.of(context).requestFocus(_focusNodeText);
                onUserAddText();
              },
              child: _wText),
        ),
      ));
    }
    return Container(
      width: double.infinity,
      height: screenSize.height,
      child: Stack(
        children: _list,
      ),
    );
  }

  Widget _buildRemove() {
    return Positioned(
      bottom: 50,
      right: 20,
      child: !_isShowRemove
          ? const SizedBox()
          : Container(
              child: DragTarget(
                builder: (context, List<String> candidateData, rejectedData) {
                  return Center(
                      child: Container(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          isActiveThungRac
                              ? Icons.delete_forever
                              : Icons.delete,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        WText(
                          'Kéo vào đây để xoá',
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          size: 13,
                        )
                      ],
                    ),
                  ));
                },
                onLeave: (_) {
                  isActiveThungRac = false;
                  setState(() {});
                },
                onWillAccept: (data) {
                  isActiveThungRac = true;
                  setState(() {});
                  return true;
                },
                onAccept: (data) {
                  var _temp = data.toString().split('-');
                  _listFile[_indexActive]
                      .listText
                      .removeAt(int.tryParse(_temp[1]));
                  _isShowRemove = false;
                  setState(() {});
                },
              ),
            ),
    );
  }

  bool isActiveThungRac = false;

  void onUserAddText({String text}) {
    _focusNodeText.requestFocus();
    setState(() {});
  }

  FocusNode _focusNodeText = FocusNode();

  TextEditingController _textEditingController = TextEditingController();

  Widget _buildWidgetText() {
    return Container(
      margin: EdgeInsets.only(bottom: 44),
      width: double.infinity,
      color: Colors.black.withOpacity(0.4),
      child: Stack(
        children: <Widget>[
          Positioned(
              left: 10,
              top: 50 + MediaQuery.of(context).padding.top,
              child: GestureDetector(
                onTap: () {
                  if (_isEditText) {
                    _isShowToolText = false;
                    _isShowStackMedia = true;
                    TextModel _text = TextModel(
                      text: _textEditingController.text,
                      top: screenSize.height / 2,
                      type: _indexType,
                      color: _listColor[_indexColorTextChoose],
                    );
                    _listFile[_indexActive].listText.add(_text);
                    _textEditingController.text = '';
                    setState(() {});
                  } else {
                    _isShowToolText = false;
                    _isShowStackMedia = true;
                    _textEditingController.text = '';
                    setState(() {});
                  }
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black54,
              child: TextField(
                autofocus: true,
                controller: _textEditingController,
                focusNode: _focusNodeText,
                onSubmitted: (data) {
                  _isShowToolText = false;
                  _isShowStackMedia = true;
                  TextModel _text = TextModel(
                    text: data,
                    top: screenSize.height / 2,
                    type: _indexType,
                    color: _listColor[_indexColorTextChoose],
                  );
                  _listFile[_indexActive].listText.add(_text);
                  _textEditingController.text = '';
                  setState(() {});
                },
                onChanged: (data) {},
                style: TextStyle(
                  color: _listColor[_indexColorTextChoose],
                  fontSize: _indexType == 0 ? 14 : _indexType == 1 ? 20 : 30,
                ),
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    hintText: 'Bắt đầu nhập...',
                    border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _indexColorTextChoose = 0;
  int _indexType = 0;

  Widget _buildToolText() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: !_isShowToolText
          ? const SizedBox()
          : Container(
              color: Colors.black45,
              padding: EdgeInsets.symmetric(vertical: 8),
              width: screenSize.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 200,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _indexType = 0;
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: _indexType == 0
                                      ? Color.fromRGBO(43, 53, 74, 1)
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: WText(
                                  'Đơn giản',
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _indexType = 1;
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: _indexType == 1
                                      ? Color.fromRGBO(43, 53, 74, 1)
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: WText(
                                  'Phụ đề'.toUpperCase(),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _indexType = 2;
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: _indexType == 2
                                      ? Color.fromRGBO(43, 53, 74, 1)
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: WText(
                                  'Cỡ chữ lớn',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: scaleWidth(100),
                    height: 30,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            _indexColorTextChoose = index;
                            setState(() {});
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 0.2),
                                color: _listColor[index]),
                          ),
                        );
                      },
                      itemCount: _listColor.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(
                          width: 8,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ),
            ),
    );
  }

  _buildStackMedia() {
    if (_isLoading) {
      return SizedBox();
    }
    return Positioned(
      left: 16,
      bottom: 60,
      right: 0,
      child: Container(
        height: 80,
        child: ListView.builder(
          itemBuilder: (_, index) {
            if (index == _listFile.length) {
              return GestureDetector(
                onTap: () async {
                  _pickAsset(multi: false);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 40,
                  height: 70,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 2.0,
                          // has the effect of softening the shadow
                          spreadRadius: 1.0,
                          // has the effect of extending the shadow
                          offset: Offset(
                            0.0, // horizontal, move right 10
                            0, // vertical, move down 10
                          ),
                        )
                      ],
                      color: Colors.white.withOpacity(0.7),
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Center(
                    child: Icon(Icons.add),
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                setState(() {
                  _isPlay = false;
                  _indexActive = index;
                });
              },
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 70,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[500],
                                blurRadius: 2.0,
                                // has the effect of softening the shadow
                                spreadRadius: 1.0,
                                // has the effect of extending the shadow
                                offset: Offset(
                                  0.0, // horizontal, move right 10
                                  0, // vertical, move down 10
                                ),
                              )
                            ],
                            color: Colors.white.withOpacity(0.7),
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: Stack(
                          children: <Widget>[
                            Image.file(
                              _listFile[index].file,
                              width: index == _indexActive ? 60 : 40,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                            index != _indexActive
                                ? SizedBox()
                                : AnimatedPositioned(
                                    duration: Duration(
                                        seconds: _isPlay
                                            ? _listFile[_indexActive].speed
                                            : 0),
                                    left: _isPlay ? 60 : 0,
                                    child: Container(
                                      width: 2,
                                      height: 70,
                                      color: Colors.white,
                                    ),
                                  )
                          ],
                        )),
                  ),
                  index == _indexActive
                      ? Positioned(
                          right: -2,
                          top: -1,
                          child: GestureDetector(
                            onTap: () {
                              if (index == _listFile.length - 1)
                                _indexActive = _indexActive - 1;
                              _listFile.removeAt(index);
                              setState(() {});
                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            );
          },
          scrollDirection: Axis.horizontal,
          itemCount: _listFile.length + 1,
        ),
      ),
    );
  }

  bool _isPlay = false;
}

class FileModel {
  String id;
  File file;
  int speed;
  bool isNext;
  List<TextModel> listText = List();

  FileModel({this.file, this.speed = 1, listText, this.id, this.isNext = true});
}

class TextModel {
  String text;
  int type;
  Color color = Colors.black;
  double left, top, right, bottom, size;

  TextModel(
      {this.left = 0,
      this.top = 40,
      this.bottom = 0,
      this.right = 0,
      this.type = 0,
      this.text,
      this.color});
}

class ShadowText extends StatelessWidget {
  ShadowText(this.data, {this.style}) : assert(data != null);

  final String data;
  final TextStyle style;

  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 2.0,
            left: 2.0,
            child: new Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          new BackdropFilter(
            filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: new Text(data, style: style),
          ),
        ],
      ),
    );
  }
}
