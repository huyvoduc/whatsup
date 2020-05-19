import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/common/const.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';
import 'package:whatsup/presentation/theme/theme_text.dart';

import 'share_post_item_widget.dart';

class SharePostWidget extends StatefulWidget {
  final PostModel post;
  final Size size;

  SharePostWidget({
    this.post,
    this.size,
  });

  @override
  _SharePostWidgetState createState() => _SharePostWidgetState();
}

class _SharePostWidgetState extends State<SharePostWidget>
    with SingleTickerProviderStateMixin {
  PostBloc _postBloc;
  AnimationController _controllerAnimation;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
    _controllerAnimation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
            begin: widget.size.height, end: widget.size.height * 2 / 3)
        .animate(_controllerAnimation)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.post.isShowShare = false;
            }
          });
    widget.post.isShowShare = false;
  }

  @override
  void dispose() {
    _controllerAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _postBloc.sharePopupStream,
      initialData: false,
      builder: (context, snapshot) {
        if (widget.post.isShowShare) {
          _controllerAnimation.forward();
        }
        return AnimatedBuilder(
          animation: _controllerAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                _animation.value,
              ),
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(number_10),
                    topRight: Radius.circular(number_10))),
            height: _animation.value,
            width: widget.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Chia sẻ với',
                  textAlign: TextAlign.justify,
                  style: ThemeText.textStyleNormalBlack15,
                ),
                SharePostItemWidget(
                  widget.post,
                  size: widget.size,
                ),
                Container(
                  alignment: Alignment.center,
                  width: widget.size.width,
                  color: Color(0xffF7F6F4),
                  child: InkWell(
                    onTap: () {
                      _controllerAnimation.reverse();
                    },
                    child: Text(
                      'Hủy',
                      textAlign: TextAlign.justify,
                      style: ThemeText.textStyleNormalBlack15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
