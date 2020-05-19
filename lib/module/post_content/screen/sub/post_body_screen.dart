import 'package:bloc_provider/bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/src/swiper_controller.dart';
import 'package:sliding_up_panel/src/panel.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/dto/multisup_dto.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';
import 'package:whatsup/module/post_content/screen/widget/multisub_widget.dart';
import 'package:whatsup/module/post_content/screen/widget/video_player_widget.dart';

import '../../../../common/const.dart';
import '../../../../model/media_model.dart';
import '../../../../model/post_model.dart';
import '../../../../utils/life_cycle/base.dart';
import 'post_header_screen.dart';

class PostBodyScreen extends StatefulWidget {
  final PostModel post;
  final SwiperController parentSwiperController;
  final int postIndex, changedIndex, lastIndex;
  final bool isPlay;
  final VideoPlayerController videoPlayerController;
  final List<VideoPlayerController> videoPlayerControllers;
  final int supPlaying;
  final SwiperController itemSwipeController;
  final PanelController panelControllerBottom;
  final PanelController panelControllerTop;

  PostBodyScreen(
      {this.post,
      this.parentSwiperController,
      this.postIndex,
      this.changedIndex,
      this.lastIndex,
      this.videoPlayerController,
      this.isPlay,
      this.videoPlayerControllers,
      this.supPlaying,
      this.itemSwipeController,
      this.panelControllerBottom,
      this.panelControllerTop});

  @override
  _PostBodyScreenState createState() => _PostBodyScreenState();
}

class _PostBodyScreenState extends BaseState<PostBodyScreen> {
  ScrollController _listViewController;
  int currentIndex = 1;
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _listViewController = ScrollController();
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  void dispose() {
    _listViewController?.dispose();
    super.dispose();
  }
  double acValue =0.0;
  @override
  Widget build(BuildContext context) {
    final headerHome = PostHeaderScreen(screenSize, widget.post);
    Widget result;
    if (widget.post.typename == PostType.singleVideo) {
      result = videoPost(headerHome);
    } else if (widget.post.typename == PostType.singleImage ||
        widget.post.typename == PostType.comic ||
        widget.post.typename == PostType.singleGif) {
      result = imagePost(headerHome);
    } else if (widget.post.typename == PostType.multisup) {
      result = multiSupPost(widget.post.mediaResources, headerHome);
    }
    return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {

//          if(scrollNotification is ScrollStartNotification){
//            if (widget.post.typename == PostType.singleVideo) {
//              print('pauseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
//              _postBloc.videoControllerAdd(false);
//            } else if (widget.post.typename == PostType.multisup) {
//              _postBloc.multisupVideoAdd(MultisupDTO()
//                ..isPlay = false);
//            }
//          }
          if(scrollNotification is OverscrollNotification){
            //onPanUpdate(notification.dragDetails, MediaQuery.of(notification.context).size.height);
            if(acValue.abs() >= 1)
              acValue = 0;
            acValue += scrollNotification.dragDetails?.primaryDelta == null ? 0 : scrollNotification.dragDetails?.primaryDelta / (screenSize.height);

            if(acValue < 0)
            {
//              print("Animate to position ${acValue.abs()} ${widget.panelControllerBottom.isPanelShown}");
              widget.panelControllerBottom.animatePanelToPosition(acValue.abs());
            }
            else
              widget.panelControllerTop.animatePanelToPosition(acValue.abs());
//            print("acValue${acValue}");
          }

          if(scrollNotification is ScrollEndNotification) {
//            print("is ScrollEndNotification acValue${acValue} ${widget.panelControllerBottom.isPanelShown} ${widget.panelControllerBottom.panelPosition}");
            if (acValue < 0) {
              if (acValue.abs() >= 0.2) {
                acValue = 0;
                widget.panelControllerBottom.open();
              } else {
                acValue = 0;
                widget.panelControllerBottom.close();
              }
            } else {
              if (acValue.abs() >= 0.3) {
                acValue = 0;
                widget.panelControllerTop.open();
              } else {
                acValue = 0;
                widget.panelControllerTop.close();
              }
            }
          }


//          if (scrollNotification is UserScrollNotification && scrollNotification.direction == ScrollDirection.forward) {
//            if (_listViewController.offset <= _listViewController.position.minScrollExtent &&
//                !_listViewController.position.outOfRange) {
//              widget.panelControllerTop.open();
//            }
//          }
//          if (scrollNotification is UserScrollNotification && scrollNotification.direction == ScrollDirection.reverse) {
//            if (_listViewController.offset >= _listViewController.position.maxScrollExtent &&
//                !_listViewController.position.outOfRange) {
//              widget.panelControllerBottom.open();
//            }
//          }
        },
        child: result);
  }

  Widget imagePost(headerHome) {
    return widget.post.dimensions.height < screenSize.height
        ?
   SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            headerHome,
            SizedBox(
              height: number_15,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                child: Image(
                  image: CachedNetworkImageProvider(
                    widget.post.mediaUrl,
                  ),
                  height: widget.post.dimensions.height,
                  width: widget.post.dimensions.width,
                ),
              ),
            ),
          ],
        )    )
//    GestureDetector(
//            onPanUpdate: (delta) {
//              if (delta.delta.dy > 0) {
//                widget.panelControllerTop.open();
//                widget.panelControllerBottom.close();
//              } else {
//                widget.panelControllerBottom.open();
//                widget.panelControllerTop.close();
//              }
//            },
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                headerHome,
//                SizedBox(
//                  height: number_15,
//                ),
//                FittedBox(
//                  fit: BoxFit.fitWidth,
//                  child: Container(
//                    child: Image(
//                      image: CachedNetworkImageProvider(
//                        widget.post.mediaUrl,
//                      ),
//                      height: widget.post.dimensions.height,
//                      width: widget.post.dimensions.width,
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          )
        : SingleChildScrollView(
      physics: ClampingScrollPhysics(),
            controller: _listViewController,
           child: Column(
               children: [
                 headerHome,
                 SizedBox(
                   height: number_5,
                 ),
                 FittedBox(
                   fit: BoxFit.fitWidth,
                   child: Image(
                     image: CachedNetworkImageProvider(
                       widget.post.mediaUrl,
                     ),
                     height: widget.post.dimensions.height,
                     width: widget.post.dimensions.width,
                   ),
                 ),
               ]
           ),);
  }

  Widget videoPost(headerHome) {
    return !widget.post.isVideoFull
        ? SingleChildScrollView(
            controller: _listViewController,
            child: Column(
              children: <Widget>[
                headerHome,
                SizedBox(
                  height: number_15,
                ),
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.7,
                  child: VideoPlayerWidget(
                    post: widget.post,
                    isShowSpeakerIcon: false,
                    index: widget.postIndex,
                    panelControllerTop: widget.panelControllerTop,
                    panelControllerBottom: widget.panelControllerBottom,
                    changedIndex: widget.changedIndex,
                    lastIndex: widget.lastIndex,
                    videoPlayerController: widget.videoPlayerController,
                  ),
                ),
              ],
            ),
          )
        : Stack(
            children: <Widget>[
              Container(
                height: screenSize.height,
                width: screenSize.width,
                child: VideoPlayerWidget(
                  post: widget.post,
                  isShowSpeakerIcon: false,
                  index: widget.postIndex,
                  panelControllerTop: widget.panelControllerTop,
                  panelControllerBottom: widget.panelControllerBottom,
                  changedIndex: widget.changedIndex,
                  lastIndex: widget.lastIndex,
                  videoPlayerController: widget.videoPlayerController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: number_40),
                child: headerHome,
              ),
            ],
          );
  }

  Widget multiSupPost(List<MediaModel> mediaResources, PostHeaderScreen headerHome) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: number_15,
        ),
        SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: MultisupWidget(
              postModel: widget.post,
              parrentSwiperController: widget.parentSwiperController,
              index: widget.postIndex,
              panelControllerBottom: widget.panelControllerBottom,
              panelControllerTop: widget.panelControllerTop,
              videoPlayerControllers: widget.videoPlayerControllers,
              changedIndex: widget.changedIndex,
              supPlaying: widget.supPlaying),
        ),
        Padding(
          padding: const EdgeInsets.only(top: number_40),
          child: headerHome,
        ),
      ],
    );
  }
}
