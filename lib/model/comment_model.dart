import 'base_model.dart';
import 'media_model.dart';
import 'post_model.dart';
import 'user_model.dart';

const String colContent = 'content';

enum CommentType {comment, reply}

class CommentModel extends BaseModel{
  String content;
  String parentId;
  String likeCount = '0', dislikeCount = '0', commentCount = '0';
  bool viewerHasLiked = false;
  bool viewerHasDisliked = false;
  bool showReplyOnComment = false;
  bool showReplyStatus = false;
  List<CommentModel> repliesDefault=[];
//  List<CommentModel> repliesRemain=[];
  int remainingReply=0;
  bool isLastDefaultReply = false;
  MediaModel media;
  CommentType type = CommentType.comment;
  bool commentHasMedia = false;
  bool isLoading=false;
  String mediaTypename;
  Dimensions dimensions;
  bool isVideoFull;

  CommentModel() : super();

}
