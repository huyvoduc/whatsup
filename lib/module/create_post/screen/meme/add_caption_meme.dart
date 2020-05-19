import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/package_constants.dart';
import 'package:whatsup/module/create_post/screen/image/select_hashtag_screen.dart';
import 'package:whatsup/utils/firebase_database_service.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

import '../upload_screen.dart';

class AddCaptionMeMeScreen extends StatefulWidget {
  final File imageAfterCrop;

  const AddCaptionMeMeScreen({Key key, this.imageAfterCrop}) : super(key: key);

  @override
  _AddCaptionMeMeScreenState createState() => _AddCaptionMeMeScreenState();
}

class _AddCaptionMeMeScreenState extends BaseState<AddCaptionMeMeScreen> {
  final FocusNode _focusNode = FocusNode();
  String textTop;
  String textBottom;
  String caption;
  double _opacity = 0;
  final FocusNode _focusNodeTop = FocusNode();
  final FocusNode _focusNodeBot = FocusNode();

  double sizeTop = 24;
  double sizeBot = 24;

  bool isFocusTop;

  @override
  void initState() {
    _focusNodeTop.addListener(() {
      if (_focusNodeTop.hasFocus) {
        _opacity = 1;
        isFocusTop = true;
        setState(() {});
      }
    });
    _focusNodeBot.addListener(() {
      if (_focusNodeBot.hasFocus) {
        _opacity = 1;
        isFocusTop = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const WText('meme'),
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
                      pushScreenOther(UpLoadSreen(
                        imageAfterCrop: widget.imageAfterCrop,
                        isMeme: true,
                        text: caption,
                        type: 'SingleImage',
                        captionTop: textTop,
                        captionBottom: textBottom,
                        tags: orginalListHashTag,
                      ));
                    },
                    behavior: HitTestBehavior.opaque,
                    child: WText(
                      'Đăng',
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
          ]),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: <Widget>[
          Container(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          _opacity = 0;
                          setState(() {});
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Image.file(
                          widget.imageAfterCrop,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        )),
                    Container(
                        width: double.infinity,
                        color: textTop == null || textTop == ""
                            ? Colors.lightBlueAccent.withOpacity(0.5)
                            : Colors.transparent,
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          focusNode: _focusNodeTop,
                          style:
                              TextStyle(color: Colors.white, fontSize: sizeTop),
                          onChanged: (data) {
                            if (textTop == null || textTop == "") {
                              textTop = data;
                              setState(() {});
                            } else {
                              textTop = data;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 15.0),
                              border: InputBorder.none,
                              hintText: 'Mô tả trên',
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              )),
                        )),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          width: double.infinity,
                          color: textBottom == null || textBottom == ""
                              ? Colors.lightBlueAccent.withOpacity(0.5)
                              : Colors.transparent,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            focusNode: _focusNodeBot,
                            style: TextStyle(
                                color: Colors.white, fontSize: sizeBot),
                            onChanged: (data) {
                              if (textBottom == null || textBottom == "") {
                                textBottom = data;
                                setState(() {});
                              } else {
                                textBottom = data;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(left: 15.0),
                                border: InputBorder.none,
                                hintText: 'Mô tả dưới',
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                )),
                          )),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 16),
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
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
              ],
            ),
          )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: _opacity,
              child: _opacity == 0
                  ? const SizedBox()
                  : Container(
                      color: const Color.fromRGBO(38, 38, 41, 1),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const WText(
                            'A',
                            size: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape()),
                            child: Slider(
                              value: isFocusTop != null
                                  ? isFocusTop ? sizeTop / 48 : sizeBot / 48
                                  : 0.5,
                              onChanged: (newValue) {
                                if (isFocusTop) {
                                  sizeTop = newValue * 48;
                                } else {
                                  sizeBot = newValue * 48;
                                }
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
          )
        ],
      ),
    );
  }

  double _value = 0.5;

  List<String> orginalListHashTag = List();

  String listHashTags = '# thêm hashtags';
}
