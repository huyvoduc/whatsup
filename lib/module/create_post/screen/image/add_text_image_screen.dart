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

class AddTextImageScreen extends StatefulWidget {
  final File imageAfterCrop;

  const AddTextImageScreen({Key key, this.imageAfterCrop}) : super(key: key);

  @override
  _AddTextImageScreenState createState() => _AddTextImageScreenState();
}

class _AddTextImageScreenState extends BaseState<AddTextImageScreen> {
  final FocusNode _focusNode = FocusNode();
  String text;
  String caption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const WText('Photo Caption'),
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
//                      _uploadFile();
                      pushScreenOther(UpLoadSreen(
                        imageAfterCrop: widget.imageAfterCrop,
                        captionTop: text,
                        type: 'SingleImage',
                        caption: caption,
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
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    color: Colors.lightBlueAccent,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
//                  focusNode: _focusNode,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      onChanged: (data) {
                        text = data;
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 15.0),
                          border: InputBorder.none,
                          hintText: 'tap to edit the caption',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          )),
                    )),
                GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Image.file(widget.imageAfterCrop)),
                Container(
                  height: MediaQuery.of(context).padding.bottom + 100,
                )
              ],
            ),
          )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16),
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
          ),
        ],
      ),
    );
  }

  List<String> orginalListHashTag = List();

  String listHashTags = '# thêm hashtags';
}
