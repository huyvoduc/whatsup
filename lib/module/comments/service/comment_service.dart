import 'package:whatsup/dto/comment_list_dto.dart';
import 'package:whatsup/dto/page_info_dto.dart';
import 'package:whatsup/model/post_model.dart';

import '../../../api/api.dart';
import '../../../model/comment_model.dart';

class CommentService {
  Future<CommentListDTO> getListComment(CommentListDTO commentListDTO, PageInfoDTO pageModel) async{
    var apiResult = await api.getCommentList(commentListDTO, pageModel);
    return apiResult;
  }

  Future<CommentListDTO> getDefaultListReply(List<CommentModel> listComment, int currentIdx, CommentModel commentModel,PostModel postModel) async{
    var apiResult =await api.getDefaultListReply(listComment, currentIdx, commentModel, postModel);
    return apiResult;
  }

  Future<CommentListDTO> getRemainingReply(List<CommentModel> listComment, int currentIdx, CommentModel commentModel, PostModel postModel, pageInfoDTO) async{
    var apiResult =await api.getRemainingReply(listComment,
        currentIdx, commentModel, postModel, pageInfoDTO);
    return apiResult;
  }
}

