import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsup/dto/multisup_dto.dart';
import 'package:whatsup/dto/page_info_dto.dart';
import 'package:whatsup/dto/post_list_dto.dart';
import 'package:whatsup/model/user_model.dart';

import '../../../model/post_model.dart';
import '../../../module/post_content/service/post_service.dart';

class PostBloc extends Bloc {
  BehaviorSubject<PostListDTO> listPostController;
  BehaviorSubject<PostModel> postController;
  BehaviorSubject<bool> likeController;
  BehaviorSubject<bool> dislikeController;
  BehaviorSubject<bool> sharePopupController;
  BehaviorSubject<bool> followController;
  BehaviorSubject<bool> videoController;
  BehaviorSubject<MultisupDTO> multisupVideoController;
  PostService postService;
  PostListType postListType;

  PostBloc({this.postListType}) {
    init();
  }

  Future<void> init() async {
    postService = PostService();
    postController = BehaviorSubject<PostModel>();
    listPostController = BehaviorSubject<PostListDTO>();
    likeController = BehaviorSubject<bool>();
    dislikeController = BehaviorSubject<bool>();
    sharePopupController = BehaviorSubject<bool>();
    followController = BehaviorSubject<bool>();
    videoController = BehaviorSubject<bool>();
    multisupVideoController = BehaviorSubject<MultisupDTO>();
  }

  Future<PostListDTO> initListPost(
      PostListType postReadStatus, PageInfoDTO pageInfo) async {
    final postListDTO = await postService.getListPost(postReadStatus, pageInfo);
    listPostController.sink.add(postListDTO);
    return postListDTO;
  }

  ///
  /// get more data
  ///
  Future<PostListDTO> getMoreDataIntoListPost(
      PostListType postReadStatus, PostListDTO data) async {
    final postListDTO =
        await postService.getListPost(postReadStatus, data.pageInfo);
    data
      ..listPost.addAll(postListDTO.listPost)
      ..pageInfo = postListDTO.pageInfo;
    listPostController.sink.add(data);
    return postListDTO;
  }

  Future<void> handleSwiper(PostListDTO postListDTO) async {
    listPostController.sink.add(postListDTO);
  }

  ValueStream<MultisupDTO> get multisupVideoStream => multisupVideoController.stream;

  void multisupVideoAdd(MultisupDTO multisupDTO) {
    multisupVideoController.sink.add(multisupDTO);
  }

  ValueStream<bool> get videoControllerStream => videoController.stream;

  void videoControllerAdd(bool isPlay) {
    videoController.sink.add(isPlay);
  }
  ValueStream<PostListDTO> get listPostStream => listPostController.stream;

  ValueStream<PostModel> get postStream => postController.stream;

  ValueStream<bool> get likeStream => likeController.stream;

  ValueStream<bool> get dislikeStream => dislikeController.stream;

  ValueStream<bool> get followStream => followController.stream;

  ValueStream<bool> get sharePopupStream => sharePopupController.stream;

  void showShareDialog(PostModel post) {
    post.isShowShare = !post.isShowShare;
    sharePopupController.sink.add(post.isShowShare);
  }

  @override
  void dispose() {
    postController?.close();
//    if (postController.isClosed){
//      listPostController?.close();
//      sharePopupController?.close();
//      dislikeController?.close();
//      likeController?.close();
//      followController?.close();
//    }
  }

  Future<void> doSubscribe(PostModel post, bool isFollow) async {
    await postService.doSubscribe(post, isFollow);
    followController.sink.add(post.owner.followedByViewer);
  }

  ///
  /// handle like and unlike
  ///
  Future<void> doLike(PostModel post, UserModel currentUser) async{
    final likeNo = int.parse(post.likeCount);
    if (!post.viewerHasLiked && !post.viewerHasDisliked) {
      post
        ..viewerHasLiked = true
        ..likeCount = (likeNo + 1).toString();
    } else if (post.viewerHasLiked) {
      post
        ..viewerHasLiked = false
        ..likeCount = (likeNo - 1).toString();
    } else if (post.viewerHasDisliked) {
      final disLikeNo = int.parse(post.dislikeCount);
      post
        ..viewerHasLiked = true
        ..viewerHasDisliked = false
        ..dislikeCount = (disLikeNo - 1).toString()
        ..likeCount = (likeNo + 1).toString();
    }
    likeController.sink.add(post.viewerHasLiked);
    await postService.doLike(post, currentUser);
  }

  ///
  /// handle dislike and un-dislike
  ///
  void doDisLike(PostModel post) {
    final disLikeNo = int.parse(post.dislikeCount);
    if (!post.viewerHasLiked && !post.viewerHasDisliked) {
      post
        ..viewerHasDisliked = true
        ..dislikeCount = (disLikeNo + 1).toString();
    } else if (post.viewerHasLiked) {
      final likeNo = int.parse(post.likeCount);
      post
        ..viewerHasLiked = false
        ..viewerHasDisliked = true
        ..likeCount = (likeNo - 1).toString()
        ..dislikeCount = (disLikeNo + 1).toString();
    } else if (post.viewerHasDisliked) {
      post
        ..viewerHasDisliked = false
        ..dislikeCount = (disLikeNo - 1).toString();
    }
    dislikeController.sink.add(post.viewerHasDisliked);
  }
}
