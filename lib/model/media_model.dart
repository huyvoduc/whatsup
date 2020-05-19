import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'base_model.dart';

enum MediaType { image, video }

class MediaModel extends BaseModel {
  String mediaUrl, mediaImgIntro;
  String height = '0', width = '0';
  FileInfo fileInfo;
  MediaType mediaType = MediaType.image;
  Thumbnail thumbnail;

  MediaModel();

  MediaModel.fromMap(Map map) {
    mediaUrl = map['media_url'];
    width = map['width'].toString();
    height = map['height'].toString();
    mediaImgIntro = map['media_img_intro'].toString();
  }

  MediaModel.fromMapForComment(Map map, String mediaUrl) {
    this.mediaUrl = mediaUrl;
    width = map['width'].toString();
    height = map['height'].toString();
    thumbnail = Thumbnail.fromMap2Max(map['thumbnail']);
  }
}

class Thumbnail {
  String height3 = '0', width3 = '0', url3 = '';
  String height4 = '0', width4 = '0', url4 = '';
  String height2 = '0', width2 = '0', url2 = '';
  String height6 = '0', width6 = '0', url6 = '';
  String heightMax = '0', widthMax = '0', urlMax = '';
  Thumbnail.fromMap3(Map map) {
    var subMap = map ['300x300'];
    height3  = subMap['height'].toString();
    width3  = subMap['height'].toString();
    url3  = subMap['url'];
  }
  Thumbnail.fromMap4(Map map) {
    var subMap = map ['400x400'];
    height4  = subMap['height'].toString();
    width4  = subMap['height'].toString();
    url4  = subMap['url'];
  }
  Thumbnail.fromMap2Max(Map map) {
    var subMap = map ['200x200'];
    height2  = subMap['height'].toString();
    width2  = subMap['height'].toString();
    url2  = subMap['url'];

    subMap = map ['max'];
    heightMax  = subMap['height'].toString();
    widthMax  = subMap['height'].toString();
    urlMax  = subMap['url'];
  }

}
