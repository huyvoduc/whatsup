import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_swiper/src/swiper_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/dto/multisup_dto.dart';
import 'package:whatsup/dto/post_list_dto.dart';
import 'package:whatsup/module/comments/screen/comment_list_screen.dart';
import 'package:whatsup/module/menu/screen/menu_screen.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';

import '../../../common/const.dart';
import '../../../model/post_model.dart';
import '../../../utils/life_cycle/base.dart';
import 'sub/post_body_screen.dart';
import 'sub/post_footer_screen.dart';

class PostItemScreen extends StatefulWidget {
  final PostModel post;
  final PostListType postListType;
  final SwiperController swiperController;
  final int index, changedIndex, lastIndex;
  final Size size;
  final PostListDTO postListDTO;
  PanelController panelController;

  PostItemScreen({
    this.post,
    this.postListType,
    this.swiperController,
    this.postListDTO,
    this.lastIndex,
    this.index,
    this.size,
    this.changedIndex,
    this.panelController,
  });

  @override
  _PostItemScreenState createState() => _PostItemScreenState();
}

class _PostItemScreenState extends BaseState<PostItemScreen> with SingleTickerProviderStateMixin {
  SwiperController _itemSwipeController;
  VideoPlayerController videoPlayerController;
  List<VideoPlayerController> videoPlayerControllers = [];
  PostBloc _postBloc;
  PanelController _panelControllerBottom;
  PanelController _panelControllerTop;

  @override
  void initState() {
    super.initState();
    initVideoPlayer();
    _postBloc = BlocProvider.of<PostBloc>(context);
    _itemSwipeController = SwiperController();
    _panelControllerBottom = PanelController();
    _panelControllerTop = PanelController();
  }

  Widget contentPost() {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: PostBodyScreen(
              post: widget.post,
              parentSwiperController: widget.swiperController,
              postIndex: widget.index,
              panelControllerBottom: _panelControllerBottom,
              panelControllerTop: _panelControllerTop,
              isPlay: true,
              changedIndex: widget.changedIndex,
              lastIndex: widget.lastIndex,
              videoPlayerController: videoPlayerController,
              videoPlayerControllers: videoPlayerControllers,
              supPlaying: supPlaying,
              itemSwipeController: _itemSwipeController),
        ),
        gradientItem(),
        footerPost(),
      ],
    );
  }

  int supPlaying = 0;
  int currentSubIteme = 1;

  Widget _listComment(
    ScrollController sc,
  ) {
    return CommentListScreen.newInstance(widget.post, screenSize, widget.swiperController, _panelControllerBottom, sc);
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      children: <Widget>[
//        Container(
//          height: collapsedBottom,
//          width: screenSize.width,
//          color: Colors.red.withOpacity(0.5),
//        ),
//        Expanded(
//            child: CommentListScreen.newInstance(
//                widget.post, screenSize, widget.swiperController, _panelControllerBottom, sc)),
//      ],
//    );
  }

  Widget _topPanel() {
    return MenuScreen(
      panelController: _panelControllerTop,
      isFromPost: true,
    );
  }

  double collapsedBottom = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        contentPost(),
        SlidingUpPanel(
          controller: _panelControllerTop,
          onPanelOpened: _handlePanelOpen,
          onPanelClosed: _handlePanelClose,
          slideDirection: SlideDirection.DOWN,
          maxHeight: screenSize.height,
          minHeight: 0,
          onPanelSlide: _pandSlide,
          panel: _topPanel(),
          body: Container(),
        ),
        SlidingUpPanel(
          controller: _panelControllerBottom,
          onPanelOpened: _handlePanelOpen,
          onPanelClosed: _handlePanelClose,
          maxHeight: screenSize.height,
          minHeight: 0,
//          minHeight: collapsedBottom,
//          collapsed: _collapsedBottom(),
          onPanelSlide: _pandSlide,
          slideDirection: SlideDirection.UP,
          panelBuilder: (ScrollController sc) => _listComment(
            sc,
          ),
          body: Container(),
        ),
      ],
    );
  }

  Widget footerPost() {
    return Positioned(
      bottom: number_40,
      width: screenSize.width,
      child: PostFooterScreen(widget.post, widget.postListType,
          itemSwipeController: _itemSwipeController, panelController: _panelControllerBottom),
    );
  }

  Widget gradientItem() {
    return Positioned(
      bottom: 0,
      width: screenSize.width,
      child: Container(
          height: number_80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black87, Colors.transparent]),
          )),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    collapsedBottom = screenSize.height * 8 / 9;
  }

  @override
  void didUpdateWidget(PostItemScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.post.typename == PostType.singleVideo) {
      videoPlayerController?.dispose();
    } else if (widget.post.typename == PostType.multisup) {
      videoPlayerControllers?.forEach((item) {
        item?.dispose();
      });
    }

    super.dispose();
  }

//  bool _isLoading = true;

  Future<void> initVideoPlayer() async {
    if (widget.post.typename == PostType.singleVideo) {
      videoPlayerController = VideoPlayerController.network(widget.post.mediaUrl);
      await videoPlayerController.initialize();
    } else if (widget.post.typename == PostType.multisup) {
      videoPlayerControllers?.clear();
      for (final media in widget.post.mediaResources) {
        final videoPlayerController = VideoPlayerController.network(media.mediaUrl);
        videoPlayerControllers.add(videoPlayerController);
      }
      await initVideoSup();
    }
  }

  Future<void> initVideoSup() async {
    for (final item in videoPlayerControllers) {
      await item.initialize();
    }
  }

  void _handlePanelOpen() {
    _postBloc.handleSwiper(widget.postListDTO..isSwipeable = false);
    if (widget.post.typename == PostType.singleVideo) {
      _postBloc.videoControllerAdd(false);
    } else if (widget.post.typename == PostType.multisup) {
      _postBloc.multisupVideoAdd(MultisupDTO()..isPlay = false);
    }
  }

  void _handlePanelClose() {
    _postBloc.handleSwiper(widget.postListDTO..isSwipeable = true);
    if (widget.post.typename == PostType.singleVideo) {
      _postBloc.videoControllerAdd(true);
    } else if (widget.post.typename == PostType.multisup) {
      _postBloc.multisupVideoAdd(MultisupDTO()..isPlay = true);
    }
  }

//  void _pandSlide(double position) {
//    print('=================$position');
//    if (position > 0) {
//      collapsedBottom = (screenSize.height * 8 / 9) * (1 - position);
//    } else if (position == 1) {
////      collapsedBottom = 0;
//    } else {
//      collapsedBottom = screenSize.height * 8 / 9;
//    }
//  }

  Widget _collapsedBottom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Container(
            height: collapsedBottom,
            color: Colors.red.withOpacity(0.5),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.red.withOpacity(0.5),
          ),
        )
      ],
    );
  }

  void _pandSlide(double position) {
    if (position != 0) {
      if (widget.post.typename == PostType.singleVideo) {
//        print('pauseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        _postBloc.videoControllerAdd(false);
      } else if (widget.post.typename == PostType.multisup) {
        _postBloc.multisupVideoAdd(MultisupDTO()..isPlay = false);
      }
    }
  }

}
