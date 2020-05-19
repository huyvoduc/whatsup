import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/src/swiper_controller.dart';
import 'package:photo/photo.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/api/api.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/module/create_post/screen/ChosseGifFromWebScreen.dart';
import 'package:whatsup/module/create_post/screen/comic/bottom_sheet_meme.dart';
import 'package:whatsup/module/create_post/screen/comic/comic.dart';
import 'package:whatsup/module/create_post/screen/image/crop_image_screen.dart';
import 'package:whatsup/module/create_post/screen/meme/meme_search_screen.dart';
import 'package:whatsup/module/create_post/screen/mutilsup/edit_mutilsup_screen.dart';
import 'package:whatsup/module/create_post/screen/video/preview_video_creen.dart';
import 'package:whatsup/module/profile/models/user.dart';
import 'package:whatsup/module/widget/user_status_widget.dart';
import 'package:whatsup/utils/pick_gif_web/giphy_picker.dart';
import 'package:whatsup/utils/pick_gif_web/widgets/giphy_preview_page.dart';
import 'package:whatsup/utils/user_manager.dart';
import '../../../utils/life_cycle/base.dart';
import 'package:image_picker/image_picker.dart';

class MenuScreen extends StatefulWidget {
  final SwiperController itemSwipeController;
  final isFromPost;
  PanelController panelController;

  MenuScreen({this.isFromPost, this.panelController, this.itemSwipeController});
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends BaseState<MenuScreen> {
  bool isCreate = false;
  final API_KEY = 'JgbxgKWctlyk2DNhQtwwOaW1KceRPKxH';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242A37),
      body: _buildBody(),
    );
  }

  String status = '';

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: status == 'on'
                ? const SizedBox()
                : Padding(
                    padding:
                        EdgeInsets.only(left: 16, top: screenSize.height / 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const Text(
                          'Nổi bật',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Mới nhất',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Đăng ký',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        UserStatusWidget(
                          onTap: () {
                            Navigator.pushNamed(context, RouteList.profile);
                          },
                          builder: (_, __) => const Text(
                            'Trang cá nhân',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          currentRoute: RouteList.menuScreen,
                        ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: scaleHeight(350),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: status == 'on'
                  ? const Text(
                      'Tạo bài viết',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  : const SizedBox(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: scaleHeight(120)),
              width: scaleWidth(360),
              height: scaleHeight(240),
              child: GestureDetector(
                onTapDown: (offset) {
                  final o = offset.localPosition;
                  if (status == 'on') {
                    if (o.dx > 0 &&
                        o.dx < scaleWidth(40) &&
                        o.dy > scaleHeight(80) &&
                        o.dy < scaleHeight(135)) {
                      ///gif
                      actionGif();
                    }
                    if (o.dx > scaleWidth(80) &&
                        o.dx < scaleWidth(120) &&
                        o.dy > scaleHeight(40) &&
                        o.dy < scaleHeight(110)) {
                      ///anh
                      actionPhoto();
                    }
                    if (o.dx > scaleWidth(160) &&
                        o.dx < scaleWidth(200) &&
                        o.dy > scaleHeight(20) &&
                        o.dy < scaleHeight(80)) {
                      ///video
                      actionVideo();
                    }

                    if (o.dx > scaleWidth(240) &&
                        o.dx < scaleWidth(280) &&
                        o.dy > scaleHeight(40) &&
                        o.dy < scaleHeight(110)) {
//                      pushScreenOther(BottomSheetSticker.newInstance());
                      pushScreenOther(CommicScreen.newInstance());

                      ///commic
                    }
                    if (o.dx > scaleWidth(320) &&
                        o.dx < scaleWidth(360) &&
                        o.dy > scaleHeight(80) &&
                        o.dy < scaleHeight(135)) {
                      ///meme
                      actionMeme();
                    }

                    if (o.dx > scaleWidth(150) &&
                        o.dx < scaleWidth(210) &&
                        o.dy > scaleHeight(170) &&
                        o.dy < scaleHeight(410)) {
                      ///multisup
                      // ignore: invariant_booleans
                      if (status == 'on') {
//                        pushScreenOther(EditMutilsSupScreen());
                      }
                    }
                  }
                  if (o.dx > scaleWidth(150) &&
                      o.dx < scaleWidth(210) &&
                      o.dy > scaleHeight(170) &&
                      o.dy < scaleHeight(410)) {
//                    if (status == '' || status == 'off') {
//                      setState(() {
//                        status = 'on';
//                      });
//                    }
                    var _status = UserManager.instance.getUserStatus();
                    if (_status == UserStatus.notLoggedIn) {
                      UserManager.instance.loginAtScreen = RouteList.menuScreen;
                      pushScreen(routerName: RouteList.loginHome);
                    }
                    // chưa hoàn thành profile thì phải complete
                    else if (_status == UserStatus.notCompleteProfile) {
                      UserManager.instance.loginAtScreen = RouteList.menuScreen;
                      pushScreen(
                          routerName: RouteList.loginInputBirthDay,
                          param: UserManager.instance.currentUser);
                    } else {

                      // login rồi thì thực hiện action của widget này
                      ///create bai viet
                      if (status == '' || status == 'off') {
                        setState(() {
                          status = 'on';
                        });
                      }else{
                        pushScreenOther(EditMutilsSupScreen());

                      }
                    }
                  } else {
                  }
                },
                child: FlareActor('assets/images/flare_menu.flr',
                    animation: status, fit: BoxFit.fitWidth),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: screenSize.height / 9,
            child: GestureDetector(
              onTap: () {

                  if (status == 'on') {
                    setState(() {
                      status = 'off';
                    });
                  } else {
                    widget.panelController.close();

                    /// pop menu
                }
              },
              child: Icon(
                Icons.close,
                color: const Color(0xffC7C7CC),
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> actionPhoto() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Chọn nguồn'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                /** */
                final result = await PhotoPicker.pickAsset(
                    context: context,
                    maxSelected: 1,
                    pickType: PickType.onlyImage);
                if (result.isNotEmpty) {
                  await result.first.file.then((image) async {
                    print('image: $image');
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CropImageScreen(
                                fileImage: image,
                                url: null,
                              )),
                    );
                  });
                }
              },
              child: const Text('Thư viện'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _getFromClipboard().then((data) async {
                  if (data == null) {
                    await showSimpleDialog(
                        message: 'looks like clipboard is empty');
                  } else {
                    if (data.contains('wwww') | data.contains('http')) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CropImageScreen(url: data)),
                      );
                    } else {
                      await showSimpleDialog(
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

  Future<String> _getFromClipboard() async {
    String text;
    final Map<String, dynamic> result =
        await SystemChannels.platform.invokeMethod('Clipboard.getData');
    if (result != null) {
      text = result['text'].toString();
    }
    return text;
  }

  Future<File> getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    return image;
  }

  Future<File> getVideo() async {
    final video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    return video;
  }

  Future<void> actionGif() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Chọn nguồn'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                final result = await PhotoPicker.pickAsset(
                    context: context,
                    maxSelected: 1,
                    isAnimated: true,
                    pickType: PickType.onlyImage);
                if (result.isNotEmpty) {
                  await result.first.file.then((image) async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GiphyPreviewPage(
                                fileImage: image,
                              )),
                    );
                  });
                }
              },
              child: const Text('Thư viện'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _getFromClipboard().then((data) async {
                  if (data == null) {
                    await showSimpleDialog(
                        message: 'looks like clipboard is empty');
                  } else {
                    if (data.contains('wwww') | data.contains('http')) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GiphyPreviewPage(
                                  url: data,
                                )),
                      );
                    } else {
                      await showSimpleDialog(
                          message: 'looks like clipboard is not link');
                    }
                  }
                });
              },
              child: const Text('Clipboard'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                status = '';
                GiphyPicker.pickGif(context: context, apiKey: API_KEY);
              },
              child: const Text('Web'),
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

  Future<void> actionMeme() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Chọn nguồn'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                await pushScreenOther(MemeSearchScreen.newInstance());
              },
              child: const Text('MemePic'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                final File image = await getImage();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CropImageScreen(
                            fileImage: image,
                            url: null,
                            isMeme: true,
                          )),
                );
              },
              child: const Text('Thư viện'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _getFromClipboard().then((data) async {
                  if (data == null) {
                    await showSimpleDialog(
                        message: 'looks like clipboard is empty');
                  } else {
                    if (data.contains('wwww') | data.contains('http')) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CropImageScreen(
                                  url: data,
                                  isMeme: true,
                                )),
                      );
                    } else {
                      await showSimpleDialog(
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

  Future<void> actionVideo() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Chọn nguồn'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                final File video = await getVideo();
                if (video != null) {
                  await pushScreenOther(PreviewVideoScreen(
                    fileVideo: video,
                  ));
                }
              },
              child: const Text('Thư viện'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                print('_MenuScreenState.actionVideo');
                await _getFromClipboard().then((data) async {
                  if (data == null) {
                    await showSimpleDialog(
                        message: 'looks like clipboard is empty');
                  } else {
                    if (data.contains('wwww') | data.contains('http')) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewVideoScreen(
                                  url: data,
                                )),
                      );
                    } else {
                      await showSimpleDialog(
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
}
