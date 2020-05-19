import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsup/module/create_post/screen/image/crop_image_screen.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

import 'bottom_sheet_meme.dart';

class EditComicScreen extends StatefulWidget {
  final ModelWidgetComic renderW;

  const EditComicScreen({Key key, this.renderW}) : super(key: key);

  @override
  _EditComicScreenState createState() => _EditComicScreenState();
}

class _EditComicScreenState extends BaseState<EditComicScreen> {
  final List<Color> _listColor = List();
  List<TextModel> _listText = List();
  List<DrawingPoints> points = List();
  List<FileImageModel> _listFileImage = List();
  List<StickerModel> _listSticker = List();


  FocusNode _focusNodeText = FocusNode();
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  @override
  void initState() {
    // ignore: cascade_invocations
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

    if (widget.renderW != null) {
      points = widget.renderW.points;
      _indexColorBackgroundChoose = widget.renderW.indexColorBackground;
      _listText = widget.renderW.listText;
      _listSticker = widget.renderW.listSticker;
      _listFileImage = widget.renderW.listFileImage;
    }

    super.initState();
  }

  Widget _comic;

  bool isFirstBuild = false;

  String dataEdit = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
            onTap: () {
              if (isShowToolText) {
                isShowToolText = false;
                setState(() {});
              }
            },
            child: GestureDetector(
              onTap: () {
                if (isShowToolText) {
                  isShowToolText = false;
                  TextModel _text = TextModel(
                      text: dataEdit,
                      color: _listColor[_indexColorTextChoose],
                      isBold: _isBold,
                      isItalic: _isItalic,
                      size: sizeText);
                  _listText.add(_text);
                  _textEditingController.text = '';
                  setState(() {});
                }else{
                  _indexColorBackgroundChoose = 0;
                   _listText = List();
                  points = List();
                  _listFileImage = List();
                  _listSticker = List();

                  setState(() {

                  });
                }
              },
              child: Icon(
                isShowToolText ? Icons.arrow_back : Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                if (_isShowToolScale) {
                  _isShowToolScale = false;
                  _indexScaleImage = null;
                  _indexScaleSticker = null;
                  setState(() {});
                } else if (isShowToolText == false) {
                  _isShowRemove = false;
                  isShowToolText = false;
                  _isShowDrawTool = false;
                  _isShowToolEditComic = false;
                  typeActive = null;
                  _isShowToolScale = false;
                  _indexScaleImage = null;

                  _indexScaleSticker = null;
                  setState(() {});
                  Future.delayed(const Duration(milliseconds: 50), () {
                    ModelWidgetComic _model = ModelWidgetComic(
                        listText: _listText,
                        listSticker: _listSticker,
                        listFileImage: _listFileImage,
                        w: _comic,
                        indexColorBackground: _indexColorBackgroundChoose,
                        points: points);
                    Navigator.pop(context, _model);
                  });
                } else {
                  isShowToolText = false;
                  TextModel _text = TextModel(
                      text: dataEdit,
                      color: _listColor[_indexColorTextChoose],
                      isBold: _isBold,
                      isItalic: _isItalic,
                      size: sizeText);
                  _listText.add(_text);
                  _textEditingController.text = '';
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.only(right: 8),
                alignment: Alignment.center,
                child: const WText(
                  'Xong',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: _buildBody(),
      ),
    );
  }

  TextEditingController _textEditingController = TextEditingController();

  Widget _buildWidgetText() {
    return Container(
      width: double.infinity,
      height: 350,
      color: Colors.black.withOpacity(0.4),
      child: Align(
        alignment: Alignment.topLeft,
        child: TextField(
          autofocus: true,
          controller: _textEditingController,
          focusNode: _focusNodeText,
          maxLines: null,
          onSubmitted: (data) {
            isShowToolText = false;
            TextModel _text = TextModel(
                text: data,
                color: _listColor[_indexColorTextChoose],
                isBold: _isBold,
                isItalic: _isItalic,
                size: sizeText);
            _listText.add(_text);
            _textEditingController.text = '';
            setState(() {});
          },
          onChanged: (data) {
            dataEdit = data;
            print('_isItalic: ${_isItalic}');
          },
          style: TextStyle(
              fontSize: sizeText,
              color: _listColor[_indexColorTextChoose],
              fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal),
          decoration: InputDecoration(
              hintText: 'Bắt đầu nhập...', border: InputBorder.none),
        ),
      ),
    );
  }

  Widget test() {
    return Draggable(
      child: Container(),
      childWhenDragging: Container(),
      feedback: Container(),
      onDraggableCanceled: (_, Offset offset) {},
    );
  }

  bool _isShowRemove = false;

    Widget _buildStackText() {
      List<Widget> _list = List();
      for (var i = 0; i < _listText.length; i++) {
        var t = _listText[i];
        var _wText = FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            width: screenSize.width,
            child: Text(
              t.text,
              style: TextStyle(
                  fontSize: t.size,
                  color: t.color,
                  fontWeight: t.isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: t.isItalic ? FontStyle.italic : FontStyle.normal),
            ),
          ),
        );
        _list.add(Positioned(
          left: t.left,
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
              if (offset.dy < MediaQuery.of(context).padding.top + 54) {
                t.top = 0;
              } else {
                t.top = offset.dy - MediaQuery.of(context).padding.top - 54;
              }
              if (offset.dy >
                  MediaQuery.of(context).padding.top + 54 + 350 - 30) {
                t.top = MediaQuery.of(context).padding.top + 54 + 350 - 100;
              }

              t.left = offset.dx;
              setState(() {});
            },
            feedback: _wText,
            child: GestureDetector(
                onTap: () {
                  _textEditingController.text = t.text;
                  FocusScope.of(context).requestFocus(_focusNodeText);
                  _listText.removeAt(i);
                  onUserAddText();
                },
                child: _wText),
          ),
        ));
      }
      return Container(
        width: double.infinity,
        height: 350,
        child: Stack(
          children: _list,
        ),
      );
    }

  Widget _buildRemove() {
    return Positioned(
      bottom: 5,
      left: screenSize.width / 3,
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
                          color: _indexColorBackgroundChoose != 3
                              ? Colors.red
                              : Colors.white,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        WText(
                          'Kéo vào đây để xoá',
                          color: _indexColorBackgroundChoose != 3
                              ? Colors.red
                              : Colors.white,
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
                  if (_temp[0] == 'text') {
                    _listText.removeAt(int.tryParse(_temp[1]));
                  } else if (_temp[0] == 'sticker') {
                    _listSticker.removeAt(int.tryParse(_temp[1]));
                  } else if (_temp[0] == 'image') {
                    _listFileImage.removeAt(int.tryParse(_temp[1]));
                  }
                  _isShowRemove = false;
                  setState(() {});
                },
              ),
            ),
    );
  }

  bool isActiveThungRac = false;

  Widget _buildContainerDraw() {
    return GestureDetector(
      onPanUpdate: (details) {
        if (_isShowDrawTool)
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
                points: renderBox.localToGlobal(details.localPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
      },
      onPanStart: (details) {
        if (_isShowDrawTool)
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
                points: renderBox.localToGlobal(details.localPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
      },
      onPanEnd: (details) {
        if (_isShowDrawTool)
          setState(() {
            points.add(null);
          });
      },
      onTap: () {
        _indexScaleImage = null;

        _indexScaleSticker = null;
        typeActive = null;
        _isShowToolScale = false;
        setState(() {});
      },
      child: !_isShowDrawTool
          ? Container(
              width: double.infinity,
              height: 350,
              child: CustomPaint(
                size: Size.infinite,
                foregroundPainter: DrawingPainter(
                  pointsList: points,
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: 350,
              child: CustomPaint(
                size: Size.infinite,
                painter: DrawingPainter(
                  pointsList: points,
                ),
              ),
            ),
    );
  }

  bool _isShowToolEditComic = true;


  Widget _buildStackSticker() {
    List<Widget> _temp = List();
    for (var i = 0; i < _listSticker.length; i++) {
      var t = _listSticker[i];

      var _wSticker = Transform.rotate(
          angle: t.rotate,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: _indexScaleSticker == i
                        ? Colors.red
                        : Colors.transparent)),
            child: Image.network(
              t.url,
              width: t.size,
              fit: BoxFit.fitWidth,
            ),
          ));
      _temp.add(Positioned(
        left: t.left,
        top: t.top,
        child: Draggable(
          data: 'sticker-$i',
          childWhenDragging: Container(),
          onDragStarted: () {
            onUserScaleSticker(index: i);

            _isShowRemove = true;
            setState(() {});
          },
          onDraggableCanceled: (_, Offset offset) {
            _isShowRemove = false;
            if (offset.dy < MediaQuery.of(context).padding.top + 54) {
              t.top = 0;
            } else {
              t.top = offset.dy - MediaQuery.of(context).padding.top - 54;
            }
            if (offset.dy >
                MediaQuery.of(context).padding.top + 54 + 350 - 30) {
              t.top = MediaQuery.of(context).padding.top + 54 + 350 - 100;
            }

            t.left = offset.dx;
            setState(() {});
          },
          feedback: _wSticker,
          child: GestureDetector(
              onTap: () {
                onUserScaleSticker(index: i);
              },
              child: _wSticker),
        ),
      ));
    }
    return Container(
      width: double.infinity,
      height: 350,
      child: Stack(
        children: _temp,
      ),
    );
  }

  bool _isShowToolScale = false;
  int _indexScaleSticker;
  int _indexScaleImage;

  ///type == 0 sticker
  ///type == 1 image
  int typeActive = -1;

  void onUserScaleSticker({int index}) {
    _indexScaleImage = null;
    typeActive = 0;
    _isShowToolScale = true;
    _indexScaleSticker = index;
    setState(() {});
  }

  void onUserScaleImage({int index}) {
    _indexScaleSticker = null;
    typeActive = 1;
    _isShowToolScale = true;
    _indexScaleImage = index;
    setState(() {});
  }

  Widget _buildStackImage() {
    if (_listFileImage == null) return SizedBox();
    List<Widget> _temp = List();
    for (var i = 0; i < _listFileImage.length; i++) {
      var t = _listFileImage[i];

      var _wImage = Transform.rotate(
          angle: t.rotate,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: _indexScaleImage == i
                        ? Colors.red
                        : Colors.transparent)),
            child: Image.file(
              t.file,
              width: t.size,
              fit: BoxFit.fitWidth,
            ),
          ));
      _temp.add(Positioned(
        left: t.left,
        top: t.top,
        child: Draggable(
          data: 'image-$i',
          childWhenDragging: Container(),
          onDragStarted: () {
            onUserScaleImage(index: i);
            _isShowRemove = true;
            setState(() {});
          },
          onDraggableCanceled: (_, Offset offset) {
            _isShowRemove = false;
            if (offset.dy < MediaQuery.of(context).padding.top + 54) {
              t.top = 0;
            } else {
              t.top = offset.dy - MediaQuery.of(context).padding.top - 54;
            }
            if (offset.dy >
                MediaQuery.of(context).padding.top + 54 + 350 - 30) {
              t.top = MediaQuery.of(context).padding.top + 54 + 350 - 100;
            }

            t.left = offset.dx;
            setState(() {});
          },
          feedback: Opacity(opacity: 0.5, child: _wImage),
          child: GestureDetector(
              onTap: () {
                onUserScaleImage(index: i);
              },
              child: _wImage),
        ),
      ));
    }
    return Container(
      width: double.infinity,
      height: 350,
      child: Stack(
        children: _temp,
      ),
    );
  }


  Widget _buildBody() {
    _comic = Stack(
      children: <Widget>[
        Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _isShowToolScale = false;
                _indexScaleImage = null;
                _indexScaleSticker = null;
                setState(() {});
              },
              child: Container(
                  width: double.infinity,
                  height: 350,
                  color: _listColor[_indexColorBackgroundChoose]),
            ),
            _buildStackImage(),
            _buildStackSticker(),
            _buildStackText(),
            _buildContainerDraw(),
            _buildRemove(),
          ],
        ),
        !isShowToolText ? const SizedBox() : _buildWidgetText(),
      ],
    );
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: screenSize.height,
          child: Column(
            children: <Widget>[
              _comic,
              !_isShowToolEditComic
                  ? const SizedBox()
                  : isShowToolText
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.only(top: 12),
                          color: Colors.black,
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: changeBackgroundColor,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _listColor[
                                              _indexColorBackgroundChoose]),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: onUserChooseTickets,
                                    child: Icon(
                                      Icons.note,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: onUserAddText,
                                    child: const Text(
                                      'Aa',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 24),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: actionPhoto,
                                    child: Icon(
                                      Icons.photo_size_select_actual,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: onUserDraw,
                                    child: Icon(
                                      Icons.brush,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              if (isShowchangeBackgroundColor)
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.white,
                                  ),
                                  height: 60,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _indexColorBackgroundChoose = index;
                                          changeBackgroundColor();
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      _indexColorBackgroundChoose ==
                                                              index
                                                          ? Colors.black
                                                          : Colors.transparent,
                                                  width: 3),
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
                                )
                              else
                                const SizedBox(),
                              _isShowDrawTool
                                  ? Container(
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(Icons.album),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (selectedMode ==
                                                          SelectedMode
                                                              .StrokeWidth)
                                                        showBottomList =
                                                            !showBottomList;
                                                      selectedMode =
                                                          SelectedMode
                                                              .StrokeWidth;
                                                    });
                                                  }),
                                              IconButton(
                                                  icon: Icon(Icons.opacity),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (selectedMode ==
                                                          SelectedMode.Opacity)
                                                        showBottomList =
                                                            !showBottomList;
                                                      selectedMode =
                                                          SelectedMode.Opacity;
                                                    });
                                                  }),
                                              IconButton(
                                                  icon: Icon(Icons.color_lens),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (selectedMode ==
                                                          SelectedMode.Color)
                                                        showBottomList =
                                                            !showBottomList;
                                                      selectedMode =
                                                          SelectedMode.Color;
                                                    });
                                                  }),
                                              IconButton(
                                                  icon: Icon(Icons.backspace),
                                                  onPressed: () {
                                                    setState(() {
                                                      var index;
                                                      for (index =
                                                              points.length - 2;
                                                          index > 0;
                                                          index--) {
                                                        if (points[index] ==
                                                            null) break;
                                                      }
                                                      showBottomList = false;
                                                      if (index != -1)
                                                        points.removeRange(
                                                            index,
                                                            points.length - 1);
                                                    });
                                                  }),
                                            ],
                                          ),
                                          Visibility(
                                            child: (selectedMode ==
                                                    SelectedMode.Color)
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: getColorList(),
                                                  )
                                                : Slider(
                                                    value: (selectedMode ==
                                                            SelectedMode
                                                                .StrokeWidth)
                                                        ? strokeWidth
                                                        : opacity,
                                                    max: (selectedMode ==
                                                            SelectedMode
                                                                .StrokeWidth)
                                                        ? 50.0
                                                        : 1.0,
                                                    min: 0.0,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        if (selectedMode ==
                                                            SelectedMode
                                                                .StrokeWidth)
                                                          strokeWidth = val;
                                                        else
                                                          opacity = val;
                                                      });
                                                    }),
                                            visible: showBottomList,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
              _buildToolScale(),
            ],
          ),
        ),
        _buildToolText(),
      ],
    );
  }

  Widget _buildToolScale() {
    return !_isShowToolScale
        ? const SizedBox()
        : (_listSticker.length <= 0 && _listFileImage.length <= 0)
            ? const SizedBox()
            : Container(
                height: 40,
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 8),
                      const WText('Xoay'),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape()),
                          child: Slider(
                            value: typeActive == 0
                                ? _listSticker[_indexScaleSticker].rotate / 6.3
                                : _listFileImage[_indexScaleImage].rotate / 6.3,
                            onChanged: (newValue) {
                              if (typeActive == 0) {
                                _listSticker[_indexScaleSticker].rotate =
                                    newValue * 6.3;
                              } else if (typeActive == 1) {
                                _listFileImage[_indexScaleImage].rotate =
                                    newValue * 6.3;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const WText('Kích thước'),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape()),
                          child: Slider(
                            value: typeActive == 0
                                ? _listSticker[_indexScaleSticker].size / 300
                                : _listFileImage[_indexScaleImage].size / 300,
                            onChanged: (newValue) {
                              if (typeActive == 0) {
                                _listSticker[_indexScaleSticker].size =
                                    newValue * 300;
                                if (_listSticker[_indexScaleSticker].size < 20)
                                  _listSticker[_indexScaleSticker].size = 20;
                              } else {
                                _listFileImage[_indexScaleImage].size =
                                    newValue * 300;
                                if (_listFileImage[_indexScaleImage].size < 20)
                                  _listFileImage[_indexScaleImage].size = 20;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  Widget _buildToolText() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: !isShowToolText
          ? const SizedBox()
          : Container(
              color: Colors.black,
              height: 40,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: showModalBottomSheetFont,
                    behavior: HitTestBehavior.opaque,
                    child: const WText(
                      'F',
                      size: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                  Container(
                    width: scaleWidth(150),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const WText(
                            'A',
                            size: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape()),
                            child: Slider(
                              value: sizeText / 48,
                              onChanged: (newValue) {
                                sizeText = newValue * 48;
                                setState(() {});
                              },
                            ),
                          ),
                          const WText(
                            'A',
                            size: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ),
            ),
    );
  }

  void showModalBottomSheetFont() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
              color: Colors.black,
              padding: const EdgeInsets.only(top: 12),
              child: Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: const WText('Choose font'),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.only(right: 8),
                        alignment: Alignment.center,
                        child: const WText(
                          'Xong',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 8,
                        ),
                        const WText('Bold'),
                        CupertinoSwitch(
                          value: _isBold,
                          onChanged: (bool value) {
                            setState(() {
                              _isBold = value;
                            });
                          },
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        const WText('Italic'),
                        CupertinoSwitch(
                          value: _isItalic,
                          onChanged: (bool value) {
                            setState(() {
                              _isItalic = value;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
    setState(() {});
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                  color: selectedColor == color
                      ? Colors.black
                      : Colors.transparent,
                  width: 3)),
        ),
      ),
    );
  }

  getColorList() {
    List<Widget> listWidget = List();
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                enableLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() => selectedColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  bool _isBold = false;
  bool _isItalic = false;

  int _indexColorBackgroundChoose = 0;
  int _indexColorTextChoose = 1;
  int _indexColorBackgroundOld = 0;

  void onUserChooseTickets() async {
    _indexScaleImage = null;
    isShowchangeBackgroundColor = false;
    _indexScaleSticker = null;
    typeActive = null;
    _isShowToolScale = false;
    setState(() {});
    final url = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              height: screenSize.height - 50,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 20,
                  ),
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                  Expanded(child: BottomSheetSticker.newInstance())
                ],
              ),
            ));
    if (url != null) {
      StickerModel model = StickerModel();
      model.url = url;
      _listSticker.add(model);
      setState(() {});
    }
  }

  void changeBackgroundColor() {
    _indexScaleImage = null;

    _indexScaleSticker = null;
    typeActive = null;
    _isShowToolScale = false;
    setState(() {
      _isShowDrawTool = false;
      isShowchangeBackgroundColor = !isShowchangeBackgroundColor;
    });
  }

  void onUserDraw() {
    _indexScaleImage = null;

    _indexScaleSticker = null;
    typeActive = null;
    _isShowToolScale = false;
    setState(() {
      isShowchangeBackgroundColor = false;
      _isShowDrawTool = !_isShowDrawTool;
    });
  }

  void onUserAddText({String text}) {
    _indexScaleSticker = null;
    _indexScaleImage = null;
    typeActive = null;
    _isShowToolScale = false;
    isShowToolText = true;
    _focusNodeText.requestFocus();
    setState(() {});
  }

  double sizeText = 24;
  bool isShowToolText = false;
  bool isShowchangeBackgroundColor = false;
  bool _isShowDrawTool = false;

  Future<void> actionPhoto() async {
    _indexScaleSticker = null;
    _indexScaleImage = null;

    typeActive = null;
    _isShowToolScale = false;
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Chọn nguồn'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                /** */
                File image = await getImage();
                var temp = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CropImageScreen(
                            fileImage: image,
                            url: null,
                            isCommic: true,
                          )),
                );
                if (temp != null) {
                  var fileImage = FileImageModel();
                  fileImage.file = temp;

                  _listFileImage.add(fileImage);
                }
                Navigator.pop(context);
              },
              child: const Text('Thư viện'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _getFromClipboard().then((data) async {
                  if (data == null) {
                    showSimpleDialog(message: 'looks like clipboard is empty');
                  } else {
                    if (data.contains('wwww') | data.contains('http')) {
                      var temp = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CropImageScreen(
                                  url: data,
                                  isCommic: true,
                                )),
                      );
                      if (temp != null) {
                        var fileImage = FileImageModel();
                        fileImage.file = temp;
                        _listFileImage.add(fileImage);
                      }
                      Navigator.pop(context);
                    } else {
                      showSimpleDialog(
                          message: 'looks like clipboard is not link');
                    }
                  }
                });
              },
              child: const Text('Clipboard'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  Future<File> getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    return image;
  }

  Future<String> _getFromClipboard() async {
    String text;
    Map<String, dynamic> result =
        await SystemChannels.platform.invokeMethod('Clipboard.getData');
    if (result != null) {
      text = result['text'].toString();
    }
    return text;
  }
}

class TextModel {
  double left, top, right, bottom, size;
  String text;
  Color color;
  bool isBold, isItalic;

  TextModel(
      {this.left = 0,
      this.top = 0,
      this.bottom = 0,
      this.right = 0,
      this.size = 14,
      this.isBold = false,
      this.isItalic = false,
      this.text,
      this.color = Colors.black});
}

class StickerModel {
  double left, top, right, bottom, size, rotate;
  String url;

  StickerModel(
      {this.left = 0,
      this.top = 0,
      this.url,
      this.right = 0,
      this.bottom = 0,
      this.size = 100,
      this.rotate = 0});
}

class FileImageModel {
  File file;
  double left, top, right, bottom, size, rotate;

  FileImageModel({
    this.file,
    this.size = 200,
    this.rotate = 0,
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }

class ModelWidgetComic {
  List<TextModel> listText = List();
  List<DrawingPoints> points = List();
  int indexColorBackground;
  Widget w;
  List<StickerModel> listSticker = List();
  List<FileImageModel> listFileImage = List();

  ModelWidgetComic(
      {this.listText,
      this.points,
      this.indexColorBackground,
      this.w,
      this.listFileImage,
      this.listSticker});
}
