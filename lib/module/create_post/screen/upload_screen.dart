import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/utils/firebase_database_service.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/user_manager.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

class UpLoadSreen extends StatefulWidget {
  final File imageAfterCrop;
  final String caption;
  final String text;
  final String captionTop, captionBottom;
  final List<String> tags;
  final bool isMeme;
  final String type;
  final double speed;

  const UpLoadSreen(
      {Key key,
      this.imageAfterCrop,
      this.caption,
      this.text,
      this.tags,
      this.type,
      this.captionTop,
      this.speed,
      this.captionBottom,
      this.isMeme = false})
      : super(key: key);

  @override
  _UpLoadSreenState createState() => _UpLoadSreenState();
}

class _UpLoadSreenState extends BaseState<UpLoadSreen> {
  @override
  void initState() {
    _uploadFile();
    // TODO: implement initState
    debugPrint('tags: ${widget.tags}');
    super.initState();
  }

  Future<void> _uploadFile() async {
    CollectionReference media_ref = await WhatsUpDBService.instance
        .getCollection(WhatsUpDBCollection.media);
    DocumentReference media_new_doc = media_ref.document();
    String media_key_id = media_new_doc.documentID;

    var upload_path =
        '${widget.type == 'SingleVideo' ? 'video' : 'images'}/${media_key_id}/${Random().nextInt(10000)}.${widget.type == 'SingleVideo' ? 'mp4' : 'jpg'}';
    print('upload_path: ${upload_path}');
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(upload_path);
    StorageUploadTask uploadTask =
        storageReference.putFile(widget.imageAfterCrop);
    await uploadTask.onComplete;
    await post(mediaRef: media_new_doc, mediaId: media_key_id);

    await storageReference.getDownloadURL().then((fileURL) {
      debugPrint('fileURL: ${fileURL}');
      media_new_doc.setData({'media_url': fileURL});
    });
  }

  Future post({DocumentReference mediaRef, String mediaId}) async {
    var owner;
    await WhatsUpDBService.instance
        .getCollection(WhatsUpDBCollection.users)
        .then((data) {
      CollectionReference _temp = data;
      owner = _temp.document(UserManager.instance.currentUser.id);
    });
    var new_post;
    if (widget.isMeme) {
      new_post = {
        'tags': widget.tags,
        'media_id': mediaId,
        'media_ref': mediaRef,
        'caption_top': widget.captionTop ?? '',
        'caption_bottom': widget.captionBottom ?? '',
        '__typename': widget.type,
        'owner_id': UserManager.instance.currentUser.id,
        'owner': owner,
      };
    } else {
      if (widget.type == 'SingleGIF') {
        new_post = {
          'tags': widget.tags,
          'media_id': mediaId,
          'media_ref': mediaRef,
          'caption': widget.caption ?? '',
          'caption_top': widget.captionTop ?? '',
          '__typename': widget.type,
          'owner_id': UserManager.instance.currentUser.id,
          'owner': owner,
          'speed': widget.speed,
        };
      } else if (widget.type == 'SingleVideo') {
        new_post = {
          'tags': widget.tags,
          'media_id': mediaId,
          'media_ref': mediaRef,
          'caption': widget.caption ?? '',
          '__typename': widget.type,
          'owner_id': UserManager.instance.currentUser.id,
          'owner': owner,
        };
      } else
        new_post = {
          'tags': widget.tags,
          'media_id': mediaId,
          'media_ref': mediaRef,
          'caption': widget.caption ?? '',
          'caption_top': widget.captionTop ?? '',
          '__typename': widget.type,
          'owner_id': UserManager.instance.currentUser.id,
          'owner': owner,
        };
    }

    await WhatsUpDBService.instance
        .getCollection(WhatsUpDBCollection.posts)
        .then((data) {
      CollectionReference _temp = data;
      _temp.add(new_post).then((data) {
        debugPrint('UPLOAD Thành công');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.file_upload,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: (60 + MediaQuery.of(context).padding.bottom).toDouble(),
              child: const Align(
                alignment: Alignment.center,
                child: WText(
                  'Đảng chờ tải lên...',
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
