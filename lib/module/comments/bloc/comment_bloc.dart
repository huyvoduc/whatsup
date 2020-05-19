import 'dart:core';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsup/dto/comment_list_dto.dart';
import 'package:whatsup/dto/page_info_dto.dart';
import 'package:whatsup/model/post_model.dart';

import '../../../model/comment_model.dart';
import '../../../module/comments/service/comment_service.dart';

class CommentBloc extends Bloc {
  CommentModel commentModel;
  CommentService commentService;
  final List<CommentModel> listComentModel;
  BehaviorSubject<CommentListDTO> listCommentController;
  BehaviorSubject<CommentModel> commentController;
  BehaviorSubject<bool> highlightCommentController;

  ValueStream<CommentListDTO> get listCommentStream =>
      listCommentController.stream;

  ValueStream<CommentModel> get commentStream => commentController.stream;

  CommentBloc({this.listComentModel, this.commentModel}) {
    listCommentController = BehaviorSubject<CommentListDTO>()..isBroadcast;
    commentController = BehaviorSubject<CommentModel>()..isBroadcast;
    highlightCommentController = BehaviorSubject<bool>();
    commentService = CommentService();
  }

  ValueStream<bool> get reactPopupStream => highlightCommentController.stream;

  Future<CommentListDTO> getListComments(
      CommentListDTO commentListDTO, PageInfoDTO pageModel) async {
    final listComment = await commentService.getListComment(commentListDTO, pageModel);
    listCommentController.add(listComment);
    return listComment;
  }

  Future<CommentListDTO> getMoreComments(
      CommentListDTO commentListDTO, PageInfoDTO pageModel) async {
    List<CommentModel> currentList = commentListDTO.listComment;
    currentList.add(CommentModel()..type=CommentType.comment..isLoading=true);
    listCommentController.sink.add(commentListDTO);
    final commentListDTOTmp = await commentService.getListComment(commentListDTO, pageModel);
    commentListDTO.listComment.removeWhere((item) => item.isLoading);
    listCommentController.add(commentListDTOTmp);
    return commentListDTO;
  }

  ///
  /// handle like and unlike
  ///
  void doLike(CommentModel comment) {
    final likeNo = int.parse(comment.likeCount);
    if (!comment.viewerHasLiked && !comment.viewerHasDisliked) {
      comment
        ..viewerHasLiked = true
        ..likeCount = (likeNo + 1).toString();
    } else if (comment.viewerHasLiked) {
      comment
        ..viewerHasLiked = false
        ..likeCount = (likeNo - 1).toString();
    } else if (comment.viewerHasDisliked) {
      final disLikeNo = int.parse(comment.dislikeCount);
      comment
        ..viewerHasLiked = true
        ..viewerHasDisliked = false
        ..dislikeCount = (disLikeNo - 1).toString()
        ..likeCount = (likeNo + 1).toString();
    }
    commentController.sink.add(comment);
  }

  ///
  /// handle dislike and un-dislike
  ///
  void doDisLike(CommentModel comment) {
    final disLikeNo = int.parse(comment.dislikeCount);
    if (!comment.viewerHasLiked && !comment.viewerHasDisliked) {
      comment
        ..viewerHasDisliked = true
        ..dislikeCount = (disLikeNo + 1).toString();
    } else if (comment.viewerHasLiked) {
      final likeNo = int.parse(comment.likeCount);
      comment
        ..viewerHasLiked = false
        ..viewerHasDisliked = true
        ..likeCount = (likeNo - 1).toString()
        ..dislikeCount = (disLikeNo + 1).toString();
    } else if (comment.viewerHasDisliked) {
      comment
        ..viewerHasDisliked = false
        ..dislikeCount = (disLikeNo - 1).toString();
    }
    commentController.sink.add(comment);
  }

  @override
  void dispose() {
//    listCommentController?.close();
//    commentController?.close();
  }

  void highlightSelectComment(CommentModel commentModel) {
    highlightCommentController.sink.add(commentModel.showReplyOnComment);
  }

  Future<void> getDefaultListReply(List<CommentModel> listComment,
      int currentIdx, CommentModel commentModel, PostModel postModel) async {
    if (commentModel.showReplyOnComment) {
      listComment.removeWhere((item) => item.type == CommentType.reply && item.parentId == commentModel.id);
      commentModel.showReplyOnComment = !commentModel.showReplyOnComment;
      listCommentController.sink.add(CommentListDTO(listComment:listComment));
    } else {
      listComment.insert(currentIdx + 1, CommentModel()..isLoading = true);
      commentModel.showReplyOnComment = !commentModel.showReplyOnComment;
      listCommentController.sink.add(CommentListDTO(listComment:listComment));
      var result = await commentService.getDefaultListReply(
          listComment, currentIdx, commentModel, postModel);
      listComment.removeWhere((item) => item.isLoading);
      listCommentController.sink.add(result);
    }
  }

  Future<void> getRemainingReply(
      List<CommentModel> listComment,
      int currentIdx,
      CommentModel commentModel,
      PostModel postModel,
      PageInfoDTO pageInfoDTO) async {
    listComment.elementAt(currentIdx).isLastDefaultReply = false;
    listComment.insert(currentIdx + 1, CommentModel()..isLoading = true);
    listCommentController.sink.add(CommentListDTO(listComment:listComment));
    var result = await commentService.getRemainingReply(
        listComment, currentIdx + 1, commentModel, postModel, pageInfoDTO);
    listComment.removeWhere((item) => item.isLoading);
    listCommentController.sink.add(result);
  }
}
