
import 'package:whatsup/dto/page_info_dto.dart';
import 'package:whatsup/dto/post_list_dto.dart';
import 'package:whatsup/model/user_model.dart';
import 'package:whatsup/utils/firebase_database_service.dart';

import '../../../api/api.dart';
import '../../../model/post_model.dart';

class PostService {
  Future<PostListDTO> getListPost(PostListType postListType,PageInfoDTO pageModel) {
    var apiResult = api.getListPost(postListType,pageModel);
    return apiResult;
  }


  Future<PostModel> doSubscribe(PostModel post, bool isFollow) async{
    var result = await api.doSubscribe(post, isFollow);
    return result;

  }

  void doLike(PostModel post, UserModel currentUser) {
    String pathLike = '';
    Map data = {
      'uid': currentUser.id,
      'ref': ''
    };
//    WhatsUpDBService.instance.doLike(post, pathLike, data);
  }
}
