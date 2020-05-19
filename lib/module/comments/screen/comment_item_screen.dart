import 'package:bloc_provider/bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/comments/bloc/comment_bloc.dart';
import 'package:whatsup/module/comments/screen/widget/pending_reply_widget.dart';

import '../../../model/comment_model.dart';
import '../../../presentation/theme/theme_text.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/life_cycle/base.dart';
import '../../pending_screen.dart';
import 'sub/comment_footer_screen.dart';
import 'widget/image_comment_view_widget.dart';
import 'widget/video_comment_player_widget.dart';

class CommentItemScreen extends StatefulWidget {
  final CommentModel commentModel;
  final int currentIdx;
  final List<CommentModel> listComment;
  final PostModel post;

  CommentItemScreen(
      {Key key,
      this.commentModel,
      this.listComment,
      this.currentIdx,
      this.post});

  @override
  _CommentItemScreenState createState() => _CommentItemScreenState();
}

class _CommentItemScreenState extends BaseState<CommentItemScreen> {
  CommentBloc _commentBloc;
  var isShowCupertinoPopup;

  @override
  void initState() {
    super.initState();
    _commentBloc = BlocProvider.of<CommentBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.commentModel.isLoading) {
      return Container(
          color: Color(0xFF242a37),
          child: SizedBox(height: 150, child: PendingReplyWidget()));
    } else {
      return Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: widget.commentModel.type == CommentType.comment ? 15 : 14,
        ),
        child: GestureDetector(
          onLongPress: () {
            if (widget.commentModel.type == CommentType.comment) {
              _showModalPopup(widget.commentModel);
            }
          },
          child: Container(
            color: Colors.transparent,
            width: screenSize.width,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // comment header
                    commentHeader(),
                    commentContent(),
                    commentFooter()
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget commentContent() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      widget.commentModel.content ?? '',
                      style: ThemeText.textStyleNormalWhite17,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  _buildAttachedMedia()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget commentFooter() {
//    if (widget.commentModel.type == CommentType.comment) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Spacer(
        flex: 1,
      ),
      Expanded(
          flex: 8,
          child: CommentFooterScreen(widget.commentModel,
              listComment: widget.listComment,
              currentIdx: widget.currentIdx,
              post: widget.post))
    ]);
//    }else {
//
//    }
  }

  Widget commentHeader() {
    final cachedNetworkImageProvider = widget.commentModel.createdBy == null
        ? AssetImage('assets/images/avatar_empty.png')
        : CachedNetworkImageProvider(
            widget.commentModel.createdBy.avatarPhotoUrl,
          );
    // comment
    if (widget.commentModel.type == CommentType.comment) {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  backgroundImage: cachedNetworkImageProvider,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Stack(
                  children: <Widget>[
                    Text(
                      widget.commentModel.createdBy?.username ?? '',
                      style: ThemeText.textStyleNormalWhite17,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 17),
                      child: Text(
                        '${DateUtils.getTimeBeforeNow(widget.commentModel.createdAt)}',
                        style: ThemeText.textStyleNormal13GreyLv2,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // replly
      return Container(
        padding: EdgeInsets.only(left: 20, top: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8),
              width: 20,
              height: 20,
              child: CircleAvatar(
                backgroundImage: cachedNetworkImageProvider,
              ),
            ),
            Flexible(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(left: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.commentModel.createdBy?.username,
                      style: ThemeText.textStyleNormalWhite17,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Center(
                        child: Text(
                          '${DateUtils.getTimeBeforeNow(widget.commentModel.createdAt)}',
                          textAlign: TextAlign.center,
                          style: ThemeText.textStyleNormal13GreyLv2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _showModalPopup(CommentModel commentModel) async {
    final result = await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {},
              child: Text(
                'Trả lời',
                style: ThemeText.textStyleNormalBlue20,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {},
              child: Text(
                'Trang cá nhân',
                style: ThemeText.textStyleNormalBlue20,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {},
              child: Text(
                'Báo Cáo',
                style: ThemeText.textStyleNormalRed20,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: ThemeText.textStyleNormalBlue20,
            ),
          ),
        );
      },
    );
//    _commentBloc.highlightSelectComment(commentModel..isReact = false);
    return result;
  }

  Widget _buildAttachedMedia() {
    if (widget.commentModel.commentHasMedia) {
      final cachedNetworkImage = CachedNetworkImage(
        imageUrl: widget.commentModel.media.thumbnail.url2,
        placeholder: (context, url) => PendingScreen(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
      if (widget.commentModel.mediaTypename == 'image') {
        return SizedBox(
          height: screenSize.height / 5,
          width: screenSize.width / 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(ImageCommentViewWidget(
                        url: widget.commentModel.media.thumbnail.urlMax,
                        commentModel: widget.commentModel,
                        size: screenSize));
                  },
                  child: cachedNetworkImage),
            ),
          ),
        );
      } else if (widget.commentModel.mediaTypename == 'video') {
        var cachedNetworkImageProvider = CachedNetworkImageProvider(
            widget.commentModel.media.thumbnail.url2);
        return InkWell(
            onTap: () {
              VideoPlayerController videoPlayerControllerInComment =
                  _loadVideo(widget.commentModel.media.mediaUrl);
              Navigator.of(context).push(VideoCommentPlayerWidget(
                  commentModel: widget.commentModel,
                  videoPlayerController: videoPlayerControllerInComment,
                  size: screenSize));
            },
            child: Container(
                height: screenSize.height / 4,
                width: screenSize.width / 3,
                alignment: FractionalOffset.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: cachedNetworkImageProvider,
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.fitWidth)),
                child: Align(
                  alignment: FractionalOffset.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenSize.width / 6 - 25),
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white.withOpacity(0.5),
                      size: 50,
                    ),
                  ),
                )));
      }
    }
    return Container();
  }

//
  VideoPlayerController _loadVideo(String mediaUrl) {
    VideoPlayerController result = VideoPlayerController.network(mediaUrl)
      ..initialize();
    return result;
  }
}
