import 'package:whatsup/dto/page_info_dto.dart';
import 'package:whatsup/model/post_model.dart';

class PostListDTO {
  List<PostModel> listPost;
  PageInfoDTO pageInfo;
  bool isSwipeable=true;
  PostListDTO(this.listPost, this.pageInfo, {this.isSwipeable=true});

}
