import 'package:whatsup/model/comment_model.dart';

import 'page_info_dto.dart';

class CommentListDTO {
  List<CommentModel> listComment;
  String postId;
  PageInfoDTO pageInfo;
  CommentListDTO({this.listComment, this.pageInfo});

}
