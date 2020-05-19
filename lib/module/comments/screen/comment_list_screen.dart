import 'dart:ui';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/src/swiper_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:whatsup/dto/comment_list_dto.dart';
import 'package:whatsup/dto/page_info_dto.dart';

import '../../../common/constanst/icon_constants.dart';
import '../../../model/comment_model.dart';
import '../../../model/post_model.dart';
import '../../../module/comments/bloc/comment_bloc.dart';
import '../../../presentation/theme/theme_text.dart';
import '../../../utils/life_cycle/base.dart';
import '../../pending_screen.dart';
import 'comment_item_screen.dart';
import 'widget/comment_input_widget.dart';
import 'widget/reply_input_widget.dart';

class CommentListScreen extends StatefulWidget {
  final PostModel postModel;
  final Size screenSize;
  final PanelController panelControllerBottom;
  final SwiperController parentSwipeController;
  final ScrollController listCommentController;

  const CommentListScreen(
      {Key key,
      this.postModel,
      this.screenSize,
      this.parentSwipeController,
      this.panelControllerBottom,
      this.listCommentController})
      : super(key: key);

  static Widget newInstance(PostModel postModel, Size screenSize, SwiperController parentSwipeController,
      PanelController panelController, ScrollController sc) {
    return BlocProvider<CommentBloc>(
      creator: (_context, _bag) => CommentBloc(listComentModel: postModel.listComment),
      child: CommentListScreen(
        postModel: postModel,
        screenSize: screenSize,
        panelControllerBottom: panelController,
        parentSwipeController: parentSwipeController,
        listCommentController: sc,
      ),
    );
  }

  @override
  _CommentListScreenState createState() => _CommentListScreenState();
}

class _CommentListScreenState extends BaseState<CommentListScreen> {
  CommentBloc _commentBloc;
  ScrollController _scrollController;
  CommentListDTO _commentListDTO;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _commentListDTO = CommentListDTO()..postId = widget.postModel.id;
    _commentBloc = BlocProvider.of<CommentBloc>(context)..getListComments(_commentListDTO, PageInfoDTO());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    widget.parentSwipeController;.addListener(_swipeListenerAtCommentList);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF242a37),
      child: StreamBuilder<CommentListDTO>(
          stream: _commentBloc.listCommentStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: GestureDetector(
                              onPanUpdate: (delta){
                                if (delta.delta.dy > 0) {
                                  widget.panelControllerBottom.close();
                                }
                              },
                              child: Container(
                                width: screenSize.width,
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        if (widget.panelControllerBottom.isAttached) widget.panelControllerBottom.close();
                                      },
                                      child: Container(
                                        width: screenSize.width * .125,
                                        height: screenSize.height * .0125,
                                        child: SvgPicture.asset(
                                          IconConstants.iconArrowDown,
                                          color: Color(0xFF979797),
                                          semanticsLabel: 'Hide',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Text(
                                        '${widget.postModel.commentCount} bình luận',
                                        style: ThemeText.textStyleNormalWhite13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (scrollInfo is ScrollEndNotification) {
                                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//                                    print('=============${widget.postModel.commentCount}====${snapshot.data.listComment.length}');
                                    if ( int.parse(widget.postModel.commentCount) > snapshot.data.listComment.length ) {
                                      _commentBloc.getMoreComments(snapshot.data, snapshot.data.pageInfo);
                                    }
                                  }
                                }
                              },
                              child: ListView(
                                controller: widget.listCommentController,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                children: _buildListComment(snapshot.data),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
//                          alignment: Alignment.bottomCenter,
                      child: SizedBox(width: screenSize.width, child: CommentInputWidget()),
                    ),
//                        CommentReactWidget(commentModel: _commentBloc.selectedComment,size: screenSize,),
                  ],
                ),
              );
            } else {
              return PendingScreen();
            }
          }),
    );
  }

  @override
  void dispose() {
    _commentBloc?.dispose();
    super.dispose();
  }

  List<Widget> _buildListComment(CommentListDTO data) {
    List<Widget> result = [];
    if (data.listComment == null || data.listComment.isEmpty) {
      result.add(Container(
        margin: EdgeInsets.only(top: screenSize.height / 3),
        alignment: Alignment.center,
        child: Text(
          'Chưa có bình luận nào',
          style: ThemeText.textStyleNormalWhite17,
        ),
      ));
    } else {
      for (int index = 0; index < data.listComment.length; index++) {
        CommentModel commentItem = data.listComment[index];
        result.add(Container(
          color: commentItem.showReplyOnComment ? Color(0xFF2e3545) : Color(0xFF242a37),
          child: CommentItemScreen(
              commentModel: commentItem, post: widget.postModel, listComment: data.listComment, currentIdx: index),
        ));
        if (commentItem.isLastDefaultReply) {
          result.add(
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FooterReplyWidget(
                    commentItem,
                    index,
                    data.listComment,
                    widget.postModel,
                    PageInfoDTO()
                      ..limit = commentItem.remainingReply
                      ..nextPageToken = commentItem.id)
              ],
            )),
          );
        }
      }
    }
    return result;
  }
}
