import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sliding_up_panel/src/panel.dart';
import 'package:whatsup/module/post_content/screen/widget/dislike_post_widget.dart';
import 'package:whatsup/module/post_content/screen/widget/like_post_widget.dart';
import 'package:whatsup/module/post_content/screen/widget/share_button_widget.dart';

import '../../../../common/const.dart';
import '../../../../common/constanst/icon_constants.dart';
import '../../../../model/post_model.dart';
import '../../../../presentation/theme/theme_text.dart';
import '../../../../utils/life_cycle/base.dart';
import '../../../../utils/number_utils.dart';

class PostFooterScreen extends StatefulWidget {
  final PostModel post;
  final PostListType postListType;
  final SwiperController itemSwipeController;
  PanelController panelController;

  PostFooterScreen(this.post, this.postListType, {this.itemSwipeController, this.panelController});

  @override
  _PostFooterScreenState createState() => _PostFooterScreenState();
}

class _PostFooterScreenState extends BaseState<PostFooterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: number_15),
          child: LikePostWidget(widget.post),
        ),
        widget.postListType != PostListType.featuredPost
            ? Padding(
                padding: const EdgeInsets.only(left: number_15),
                child: DislikePostWidget(widget.post),
              )
            : Container(),
        Spacer(
          flex: number_1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: number_15),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (widget.panelController.isAttached) widget.panelController.open();
                },
                child: SvgPicture.asset(IconConstants.iconCommentPath, color: Colors.white, semanticsLabel: 'Comment'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: number_3),
                child: Text(
                  NumberUtils.handleNumber(widget.post.commentCount),
                  style: ThemeText.textStyleNormalWhite15,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: number_15, right: number_15),
          child: ShareButtonWidget(
            color: Colors.white,
            post: widget.post,
            isShow: true,
          ),
        ),
      ],
    );
  }
}
