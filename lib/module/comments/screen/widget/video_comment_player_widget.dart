import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/model/comment_model.dart';

class VideoCommentPlayerWidget extends ModalRoute<void> {
  final CommentModel commentModel;
  final VideoPlayerController videoPlayerController;
  Size size;

  VideoCommentPlayerWidget(
      {this.commentModel, this.videoPlayerController, this.size});

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    videoPlayerController.play();
    return Material(
      child: Container(
        color: const Color(0xff242A37),
        child: commentModel.isVideoFull
            ? Stack(
                children: <Widget>[
                  Container(
                    width: size.width,
                    height: size.height,
                    child: AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      //widget.size.width/_controller.value.size.width, //_controller.value.aspectRatio
                      child: Stack(
                        children: <Widget>[
                          VideoPlayer(
                            videoPlayerController,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 10),
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          videoPlayerController.pause();
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          videoPlayerController.pause();
                          Navigator.of(context).pop();
                        }),
                  ),
                  AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    //widget.size.width/_controller.value.size.width, //_controller.value.aspectRatio
                    child: Stack(
                      children: <Widget>[
                        VideoPlayer(
                          videoPlayerController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
