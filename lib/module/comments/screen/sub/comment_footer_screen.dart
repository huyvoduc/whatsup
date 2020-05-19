import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsup/model/post_model.dart';

import '../../../../common/const.dart';
import '../../../../common/constanst/icon_constants.dart';
import '../../../../model/comment_model.dart';
import '../../../../module/comments/bloc/comment_bloc.dart';
import '../../../../presentation/theme/theme_text.dart';
import '../../../../utils/life_cycle/base.dart';
import '../../../../utils/number_utils.dart';
import 'share_comment_widget.dart';

class CommentFooterScreen extends StatefulWidget {
  final CommentModel commentModel;
  final ScrollController scrollController;
  final List<CommentModel> listComment;
  final int currentIdx;
  final PostModel post;

  CommentFooterScreen(this.commentModel,
      {this.scrollController, this.listComment, this.currentIdx, this.post});

  @override
  _CommentFooterScreenState createState() => _CommentFooterScreenState();
}

class _CommentFooterScreenState extends BaseState<CommentFooterScreen> {
  CommentBloc _commentBloc;

  @override
  void initState() {
    super.initState();
    _commentBloc = BlocProvider.of<CommentBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.commentModel.type == CommentType.reply) {
      return reply(widget.commentModel);
    }
    return comment();
  }

  Widget reply(CommentModel reply) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: number_15, top: 6),
          child: StreamBuilder<CommentModel>(
              stream: _commentBloc.commentController,
              initialData: widget.commentModel,
              builder: (context, snapshot) {
                return InkWell(
                  onTap: () {
                    _commentBloc.doLike(reply);
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(IconConstants.iconLikePath,
                          width: 20,
                          height: 16.9,
                          color: reply.viewerHasLiked
                              ? Colors.blue
                              : Colors.grey,
                          semanticsLabel: 'Like'),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          NumberUtils.handleNumber(reply.likeCount),
                          style: ThemeText.textStyleNormalGrey15,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 6),
          child: StreamBuilder<CommentModel>(
              stream: _commentBloc.commentController,
              initialData: widget.commentModel,
              builder: (context, snapshot) {
                return InkWell(
                  onTap: () {
                    _commentBloc.doDisLike(reply);
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(IconConstants.iconDisLikePath,
                          width: 20,
                          height: 16.9,
                          color: reply.viewerHasDisliked
                              ? Colors.blue
                              : Colors.grey,
                          semanticsLabel: 'Dislike'),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 6,
                        ),
                        child: Text(
                          NumberUtils.handleNumber(reply.dislikeCount),
                          style: ThemeText.textStyleNormalGrey15,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        Spacer(
          flex: number_1,
        ),
        Spacer(
          flex: number_1,
        ),
        Spacer(
          flex: number_1,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: number_15, right: number_15, top: 6),
          child: ShareCommentWidget(
            onTap: () {},
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget comment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: number_15, top: 6),
          child: StreamBuilder<CommentModel>(
              stream: _commentBloc.commentController,
              initialData: widget.commentModel,
              builder: (context, snapshot) {
                return InkWell(
                  onTap: () {
                    _commentBloc.doLike(widget.commentModel);
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(IconConstants.iconLikePath,
                          width: 20,
                          height: 16.9,
                          color: widget.commentModel.viewerHasLiked
                              ? Colors.blue
                              : Colors.grey,
                          semanticsLabel: 'Like'),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          NumberUtils.handleNumber(
                              widget.commentModel.likeCount),
                          style: ThemeText.textStyleNormalGrey15,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 6),
          child: StreamBuilder<CommentModel>(
              stream: _commentBloc.commentController,
              initialData: widget.commentModel,
              builder: (context, snapshot) {
                return InkWell(
                  onTap: () {
                    _commentBloc.doDisLike(widget.commentModel);
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(IconConstants.iconDisLikePath,
                          width: 20,
                          height: 16.9,
                          color: widget.commentModel.viewerHasDisliked
                              ? Colors.blue
                              : Colors.grey,
                          semanticsLabel: 'Dislike'),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 6,
                        ),
                        child: Text(
                          NumberUtils.handleNumber(
                              widget.commentModel.dislikeCount),
                          style: ThemeText.textStyleNormalGrey15,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        Spacer(
          flex: number_1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: number_15, top: 6),
          child: InkWell(
            onTap: () {
              final loadingItem =
                  widget.listComment.where((item) => item.isLoading == true);
              if (loadingItem.length > 0) {
                return;
              }
              _commentBloc.getDefaultListReply(widget.listComment,
                  widget.currentIdx, widget.commentModel, widget.post);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset(IconConstants.iconCommentPath,
                    width: 19.53,
                    height: 19.53,
                    color: widget.commentModel.showReplyOnComment
                        ? Colors.blue
                        : Colors.grey,
                    semanticsLabel: 'Comment'),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 6,
                  ),
                  child: Text(
                    NumberUtils.handleNumber(
                        widget.commentModel.remainingReply.toString()),
                    style: widget.commentModel.showReplyOnComment
                        ? ThemeText.textStyleNormalBlue15
                        : ThemeText.textStyleNormalGrey15,
                  ),
                )
              ],
            ),
          ),
        ),
        Spacer(
          flex: number_1,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: number_15, right: number_15, top: 6),
          child: ShareCommentWidget(
            onTap: () {},
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
