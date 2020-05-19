import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/dto/multisup_dto.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';
import 'package:whatsup/utils/life_cycle/base.dart';

class MultisupWidget extends StatefulWidget {
  final PostModel postModel;
  final SwiperController parrentSwiperController;
  final int index, changedIndex, supPlaying;
  final List<VideoPlayerController> videoPlayerControllers;
  final PanelController panelControllerTop;
  final PanelController panelControllerBottom;

  MultisupWidget(
      {@required this.postModel,
      this.parrentSwiperController,
      this.index,
      this.changedIndex,
      this.panelControllerTop,
      this.panelControllerBottom,
      this.videoPlayerControllers,
      this.supPlaying});

  @override
  _MultisupWidgetState createState() => _MultisupWidgetState();
}

class _MultisupWidgetState extends BaseState<MultisupWidget> {
  VideoPlayerController _controller;
  int _playingIndex = 0;
  PostBloc _postBloc;
  MultisupDTO multisupDTO;

  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
    _playingIndex = widget.supPlaying;
    multisupDTO = MultisupDTO(playingIndex: _playingIndex, isPlay: true);
    _controller = widget.videoPlayerControllers[_playingIndex]..addListener(_newListener);
//    if (widget.index == widget.changedIndex || (widget.index == 0 && null == widget.changedIndex)) {
//      _controller.play();
//    } else {
//      _controller.pause();
//    }
  }

  @override
  void dispose() {
//    widget.videoPlayerControllers?.forEach((item) {
//      if(item.hasListeners){
//        item.removeListener(_newListener);
//      }
//    });
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('change multisuppppppppppppp');
  }

  @override
  void didUpdateWidget(MultisupWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final width = screenSize.width;
    final height = screenSize.height;
    if (widget.index == widget.changedIndex || (widget.index == 0 && null == widget.changedIndex)) {
      _controller.play();
    } else {
      _controller.pause();
    }
    return StreamBuilder<MultisupDTO>(
      stream: _postBloc.multisupVideoStream,
      initialData: multisupDTO,
      builder: (context, snapshot) {
        if (snapshot.data.isPlay){
          _controller.play();
        } else {
          _controller.pause();
        }

        return ListView.builder(
          itemCount: 1,
          itemBuilder: (context,index) => SizedBox(
            width: width,
            height: height,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: <Widget>[
                  VideoPlayer(
                    _controller,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: screenSize.width / 4,
                      height: screenSize.height,
                      child: InkWell(
                        onTap: () {
                          if (_playingIndex == 0) {
                            if (widget.index == 0) {
                              return;
                            }
                            widget.parrentSwiperController.previous(animation: true);
                          } else {
                            _startPlay(_playingIndex - 1);
                          }
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: screenSize.width / 4,
                      height: screenSize.height,
                      child: InkWell(
                        onTap: () {
                          if (_playingIndex == widget.postModel.mediaResources.length - 1)
                            widget.parrentSwiperController.next(animation: true);
                          else
                            _startPlay(_playingIndex + 1);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  void _startPlay(int i) {
    _controller.pause().then((_) async {
      _controller = widget.videoPlayerControllers[i];
      await _controller?.seekTo(const Duration(milliseconds: 0));
      _playingIndex = i;
      setState(() {});
    });
  }

  Future<void> _newListener() async {
    if (_controller.value.initialized) {
      if (!_controller.value.isPlaying) {
        if (_controller.value.position == _controller.value.duration) {
          if (_playingIndex == widget.videoPlayerControllers.length - 1) {
            _playingIndex = 0;
          } else {
            _playingIndex = _playingIndex + 1;
          }

          if (mounted) {
            setState(() {
              _controller = widget.videoPlayerControllers[_playingIndex]..seekTo(Duration(milliseconds: 0));
            });
          }
        }
      }
    }
  }
}
