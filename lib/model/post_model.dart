import 'base_model.dart';
import 'comment_model.dart';
import 'media_model.dart';
import 'user_model.dart';

const String colCommentCount = 'comment_count';
const String colMediaUrl = 'media_url';
const String colMediaResources = 'media_resources';
const String colLikeCount = 'like_count';
const String colDislikeCount = 'dislike_count';
const String colTypeName = '__typename';
const String colCaption = 'caption';
const String colDimensions = 'dimensions';
const String colOwner = 'owner';
const String colViewerHasLiked = 'viewer_has_liked';
const String colViewerHasDisliked = 'viewer_has_disliked';
const String colThumbnailUrl = 'thumbnail_url';
const String colTags = 'tags';

//SINGLE_IMAGE: "SingleImage",
//SINGLE_GIF: "SingleGIF",
//SINGLE_VIDEO: "SingleVideo",
//COMIC: "Comic",
//MULTISUP: "Multisup"
enum PostType { singleImage, singleGif, singleVideo, comic, multisup }

enum PostListType { featuredPost, newestPost, subscriptionPost }

class PostModel extends BaseModel {
  PostType __typename;
  UserModel owner;
  String mediaUrl;
  String likeCount = '0', dislikeCount = '0', commentCount = '0';
  bool viewerHasLiked = false;
  bool viewerHasDisliked = false;
  List<MediaModel> mediaResources;
  String caption = '';
  String thumbnailUrl = '';
  bool isVideoFull;
  bool isShowShare = false;

  List<CommentModel> listComment=[];

  Dimensions dimensions;

  // ignore: unnecessary_getters_setters
  PostType get typename => __typename;

  // ignore: unnecessary_getters_setters
  set typename(PostType value) {
    __typename = value;
  }

  PostModel();



  PostModel.fromJson(Map<dynamic, dynamic> json) {
    id = json[id];
    dislikeCount = json[colDislikeCount];
    likeCount = json[colLikeCount];
    commentCount = json[colCommentCount];
    mediaUrl = json[colMediaUrl];
    caption = json[colCaption];
  }

  Map<String, dynamic> toJson() => {
        colId: id,
      };

  static List<MediaModel> buildListMediaModel (List mediaList) {
    final List<MediaModel> result = [];
    mediaList.forEach((item)async {
      final mediaModel = MediaModel.fromMap(item);
      result.add(mediaModel);

    });
    return result;
  }

  static PostType postTypeConverter(String apiResPonse, mediaUrl) {
    PostType postType;
    switch (apiResPonse) {
      case 'SingleImage':
        {
          postType = PostType.singleImage;
        }
        break;
      case 'SingleGIF':
        {
          postType = PostType.singleGif;
        }
        break;
      case 'SingleVideo':
        {
          postType = PostType.singleVideo;
        }
        break;
      case 'Comic':
        {
          postType = PostType.comic;
        }
        break;
      case 'Multisup':
        {
          postType = PostType.multisup;
        }
        break;
    }
    return postType;
  }
}



class Dimensions {
  double _height, _width;


  // ignore: unnecessary_getters_setters
  double get height => _height;

  set height(double value) {
    _height = value;
  }

  Dimensions.fromMap(Map<dynamic, dynamic> map) {
    height = map['height'].toDouble();
    width = map['width'].toDouble();
  }

  double get width => _width;

  set width(value) {
    _width = value;
  }
}
