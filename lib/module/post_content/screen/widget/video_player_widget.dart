import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/src/panel.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';
import 'package:whatsup/utils/life_cycle/base.dart';

class VideoPlayerWidget extends StatefulWidget {
  final PostModel post;
  final bool isShowSpeakerIcon;
  final int index, changedIndex, lastIndex;
  final VideoPlayerController videoPlayerController;
//  bool isPlay;
  final PanelController panelControllerTop;
  final PanelController panelControllerBottom;

  VideoPlayerWidget({
    @required this.post,
    @required this.videoPlayerController,
    this.isShowSpeakerIcon = false,
    this.index,
    this.lastIndex,
    this.changedIndex,
//    this.isPlay,
    this.panelControllerTop,
    this.panelControllerBottom,
  });

  @override
  _VideoPlayerWidgetState createState() {
    return _VideoPlayerWidgetState();
  }
}

class _VideoPlayerWidgetState extends BaseState<VideoPlayerWidget> {
  double volumeSet = 1.0;
  PostBloc _postBloc;
  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.setLooping(true);
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = screenSize.width;
    final height = screenSize.height;
//    print('====${widget.index}=====${widget.changedIndex}');
    if (widget.index == widget.changedIndex || (widget.index == 0 && null == widget.changedIndex)) {
//      isPlay = true;
    } else {
      widget.videoPlayerController.pause();
      return Container();
    }
    return StreamBuilder<bool>(
        stream: _postBloc.videoControllerStream,
        initialData: true,
        builder: (context, snapshot) {
          if (snapshot.data) {
            widget.videoPlayerController.play();
          } else {
            widget.videoPlayerController.pause();
          }
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context,index){
              return SizedBox(
                width: width,
                height: height,
                child: AspectRatio(
                  aspectRatio: widget.videoPlayerController.value.aspectRatio,
                  //widget.size.width/_controller.value.size.width, //_controller.value.aspectRatio
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(
                        widget.videoPlayerController,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  void dispose() {
//    widget.videoPlayerController?.dispose();
    super.dispose();
  }
}
