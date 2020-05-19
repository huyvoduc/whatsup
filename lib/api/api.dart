import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:whatsup/dto/comment_list_dto.dart';
import 'package:whatsup/dto/page_info_dto.dart';
import 'package:whatsup/dto/post_list_dto.dart';
import 'package:whatsup/model/base_model.dart';
import 'package:whatsup/model/media_model.dart';
import 'package:whatsup/model/user_model.dart';
import 'package:whatsup/module/create_post/screen/comic/model/album_model.dart';
import 'package:whatsup/module/create_post/screen/meme/meme_web_model.dart';

import '../common/const.dart';
import '../model/comment_model.dart';
import '../model/post_model.dart';
import 'func_name.dart' as fname;

class Api {
  Api._internal();

  static final Api _api = Api._internal();

  // ignore: sort_unnamed_constructors_first
  factory Api() {
    return _api;
  }

  CloudFunctions cloudFunc = CloudFunctions(
    region: 'asia-east2',
  );

  Future<List<AlbumModel>> postVideo() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();
    print('remoteConfig: '
        '${remoteConfig.getValue('meme_resource_list').asString()}');
    List<AlbumModel> tmp = albumModelFromJson(
        remoteConfig.getValue('meme_resource_list').asString());
    return tmp;
  }



  Future<List<AlbumModel>> getAlbumListComic() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();
    print('remoteConfig: '
        '${remoteConfig.getValue('meme_resource_list').asString()}');
    List<AlbumModel> tmp = albumModelFromJson(
        remoteConfig.getValue('meme_resource_list').asString());
    return tmp;
  }

  Future<List<dynamic>> getListSticker({String type}) async {
    const funcName = 'comic_sticker';

    final tmp = await cloudFunc
        .getHttpsCallable(functionName: funcName)
        .call(<String, dynamic>{
      'album_id': type,
    }).timeout(Duration(seconds: number_60));
    List<dynamic> data = tmp.data['data'];
    return data;
  }

  Future<dynamic> memeResoureListComics() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    final defaults = <String, dynamic>{'parameter': 'meme_resource_list'};
    await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();
    print('remoteConfig: '
        '${remoteConfig.getValue('meme_resource_list').asString()}');
  }

  Future<dynamic> getListMemeComics() async {
    const funcName = 'meme_resource_list';

    final tmp = await cloudFunc
        .getHttpsCallable(functionName: funcName)
        .call(<String, dynamic>{'type': 'miscellaneous', 'name': 'Hỗn hợp'}).timeout(Duration(seconds: number_60));
    print('reponse: ${tmp.data.toString()}');
    return null;
  }

  Future<MemeWebModel> getListMeMeWeb({String type}) async {
    const funcName = 'meme_resource';

    final tmp = await cloudFunc
        .getHttpsCallable(functionName: funcName)
        .call(<String, dynamic>{'type': type}).timeout(Duration(seconds: number_60));
    print('reponse: ${tmp.data.toString()}');
    final MemeWebModel model = MemeWebModel.fromJson(tmp.data);
    return model;
  }

  Future<MemeWebModel> searchMeMeWeb({String text}) async {
    const funcName = 'meme_resource_searching';

    final tmp = await cloudFunc
        .getHttpsCallable(functionName: funcName)
        .call(<String, dynamic>{'text': text}).timeout(Duration(seconds: number_60));
    print('reponse: ${tmp.data.toString()}');
    final MemeWebModel model = MemeWebModel.fromJson(tmp.data);
    return model;
  }

  Future<PostListDTO> getListPost(PostListType postListType, PageInfoDTO pageModel) async {
    final funcName = getPostListType(postListType);

    List<PostModel> result = [];
    try {
      final tmp = await cloudFunc.getHttpsCallable(functionName: funcName).call(<String, dynamic>{
        "limit": pageModel.limit,
//        "limit": 3,
        "next_page_token": pageModel.nextPageToken
      }).timeout(Duration(seconds: number_60));
      if (tmp != null && tmp.data['data']['posts'] != null) {
        tmp.data['data']['posts'].forEach((item) {
          try {
            final postModel = PostModel()
              ..commentCount = item[colCommentCount].toString()
              ..mediaUrl = item[colMediaUrl]
              ..mediaResources =
                  item[colMediaResources] == null ? null : PostModel.buildListMediaModel(item[colMediaResources])
              ..dislikeCount = item[colDislikeCount].toString()
              ..likeCount = item[colLikeCount].toString()
              ..id = item[colId]
              ..thumbnailUrl = item[colThumbnailUrl]
              ..typename = PostModel.postTypeConverter(item[colTypeName], item[colMediaUrl])
              ..caption = item[colCaption]
              ..dimensions = Dimensions.fromMap(item['dimensions'])
              ..owner = UserModel.fromJsonDynamic(item[colOwner])
              ..viewerHasDisliked = item[colViewerHasDisliked]
              ..viewerHasLiked = item[colViewerHasLiked];
            if (postModel.typename == PostType.singleVideo) {
              postModel.isVideoFull = processVideo(postModel);
            }
            result.add(postModel);
          } catch (ex) {
            print('ERROR: ${ex}');
            result.add(PostModel()..error = ex.toString());
          }
        });
        if (tmp != null && tmp.data['data']['page_info'] != null) {
          pageModel = PageInfoDTO.fromMap(tmp.data['data']['page_info']);
        }
      }
    } catch (e) {
      print('ERROR: ${e}');
      result.add(PostModel()..error = e.toString());
    }
    return PostListDTO(result, pageModel);
  }

  Future<PostModel> doSubscribe(PostModel post, bool isFollow) async {
    try {
      var tmp = await cloudFunc
          .getHttpsCallable(functionName: isFollow ? fname.follow : fname.unfollow)
          .call(<String, String>{"follow_id": post.owner.id});

      if (tmp != null && tmp.data != null) {
        if (tmp.data['status'] == 'ok') {
          post.owner.followedByViewer = !post.owner.followedByViewer;
        }
      }
      return post;
    } catch (e) {
      debugPrint(e);
    }
    return post;
  }

  String getPostListType(PostListType postListType) {
    if (PostListType.featuredPost == postListType) {
      return fname.featuredPost;
    } else if (PostListType.subscriptionPost == postListType) {
      return fname.subscriptionPost;
    } else if (PostListType.newestPost == postListType) {
      return fname.newestPost;
    }
    return postListType.toString();
  }

  Future<CommentListDTO> getCommentList(CommentListDTO commentListDTO, PageInfoDTO pageModel) async {
    List<CommentModel> result = [];
    try {
      final tmp = await cloudFunc.getHttpsCallable(functionName: fname.getCommentList).call(<String, dynamic>{
        "postId": commentListDTO.postId,
        "limit": pageModel.limit,
//        "limit": 3,
        "next_page_token": pageModel.nextPageToken
      }).timeout(Duration(seconds: number_60));
      if (tmp != null && tmp.data['data']['comments'] != null) {
        tmp.data['data']['comments'].forEach((item) {
          try {
            final commentModel = buildCommonCommentData(item, CommentType.comment)
              ..remainingReply = item['reply_count'];

            result.add(commentModel);
          } catch (ex) {
            print('ERROR: ${ex}');
            result.add(CommentModel()..error = ex.toString());
          }
        });
        if (tmp != null && tmp.data['data']['page_info'] != null) {
          pageModel = PageInfoDTO.fromMap(tmp.data['data']['page_info']);
        }
      }
    } catch (e) {
      print('ERROR: ${e}');
      result.add(CommentModel()..error = e.toString());
    }
    if (commentListDTO.listComment==null || commentListDTO.listComment.isEmpty) {
      return commentListDTO
        ..listComment = result
        ..pageInfo = pageModel;
    } else {

      commentListDTO.listComment.addAll(result);
      return commentListDTO
        ..pageInfo = pageModel;
    }
  }

  Future<CommentListDTO> getDefaultListReply(
    List<CommentModel> listComment,
    int currentIdx,
    CommentModel commentModel,
    PostModel postModel,
  ) async {
    List<CommentModel> result = [];
    PageInfoDTO pageModel = PageInfoDTO();

    //is showing, need to hide
    try {
      final tmp = await cloudFunc.getHttpsCallable(functionName: fname.getReplyList).call(<String, dynamic>{
        "postId": postModel.id,
        "commentId": commentModel.id,
        "limit": defaultTotalReply,
        "next_page_token": ''
      }).timeout(Duration(seconds: number_60));

      if (tmp != null && tmp.data['data']['comments'] != null) {
        for (int i = 0; i < tmp.data['data']['comments'].length; i++) {
          final item = tmp.data['data']['comments'][i];
          try {
            final reply = buildCommonCommentData(item, CommentType.reply)
              ..remainingReply = commentModel.remainingReply - defaultTotalReply
              ..parentId = commentModel.id
              ..isLastDefaultReply = (i == defaultTotalReply - 1);
            result.add(reply);
          } catch (ex) {
            print('ERROR: ${ex}');
          }
        }
        if (tmp != null && tmp.data['data']['page_info'] != null) {
          pageModel = PageInfoDTO.fromMap(tmp.data['data']['page_info']);
        }
      }
    } catch (e) {
      print('ERROR: ${e}');
    }
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    listComment.insertAll(currentIdx + 1, result);
//    commentModel.showReplyOnComment = !commentModel.showReplyOnComment;
    return CommentListDTO(listComment: listComment, pageInfo: pageModel);
  }

  Future<CommentListDTO> getRemainingReply(List<CommentModel> listComment, int currentIdx, CommentModel commentModel,
      PostModel postModel, PageInfoDTO pageInfoDTO) async {
    List<CommentModel> result = [];

    //is showing, need to hide
    if (commentModel.showReplyOnComment) {
      listComment.removeWhere((item) => item.type == CommentType.reply);
      //is hiding, need to show
    } else {
      try {
        final tmp = await cloudFunc.getHttpsCallable(functionName: fname.getReplyList).call(<String, dynamic>{
          "postId": postModel.id,
          "commentId": commentModel.parentId,
          "limit": defaultPageReply,
          "next_page_token": pageInfoDTO.nextPageToken
        }).timeout(Duration(seconds: number_60));
        if (tmp != null && tmp.data['data']['comments'] != null) {
          for (int i = 0; i < tmp.data['data']['comments'].length; i++) {
            final item = tmp.data['data']['comments'][i];
            try {
              final reply = buildCommonCommentData(item, CommentType.reply)
                ..remainingReply = pageInfoDTO.limit - defaultPageReply
                ..parentId = commentModel.parentId;
              if (i == 9) {
                reply.isLastDefaultReply = true;
                pageInfoDTO.nextPageToken = reply.id;
              }
              result.add(reply);
            } catch (ex) {
              print('ERROR: ${ex}');
            }
          }
        }
      } catch (e) {
        print('ERROR: ${e}');
      }
      if (result.length < 10) {
        final lastElement = result.elementAt(result.length - 1);
        lastElement.isLastDefaultReply = true;
        lastElement.remainingReply = 0;
      }
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      listComment.insertAll(currentIdx, result);
    }

    return CommentListDTO(listComment: listComment, pageInfo: pageInfoDTO);
  }

  CommentModel buildCommonCommentData(item, CommentType commentType) {
    CommentModel result = CommentModel()
      ..commentCount = item[colCommentCount].toString()
      ..dislikeCount = item[colDislikeCount].toString()
      ..likeCount = item[colLikeCount].toString()
      ..type = commentType
      ..content = item['comment_text'].toString()
      ..createdBy = UserModel.fromJsonDynamic(item[colOwner])
      ..id = item[colId]
      ..createdAt = DateTime.fromMillisecondsSinceEpoch(int.parse(item['created_at'].toString()))
      ..commentHasMedia = item['comment_has_media']
      ..mediaTypename = item['media_typename']
      ..dimensions = Dimensions.fromMap(item['dimensions'])
      ..viewerHasDisliked = item[colViewerHasDisliked]
      ..viewerHasLiked = item[colViewerHasLiked];
    if (result.commentHasMedia) {
      result.media = MediaModel.fromMapForComment(item, item['media_url']);
      if (result.mediaTypename == 'video') {
        result.isVideoFull = processVideo(result);
      }
    }
    return result;
  }

  bool processVideo(var postModel) {
    if (((postModel.dimensions.width / postModel.dimensions.height) - (9 / 16)).abs() > 0.15) {
      return false;
    } else {
      return true;
    }
  }
}

Api api = Api();
