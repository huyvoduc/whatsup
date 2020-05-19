// To parse this JSON data, do
//
//     final memeWebModel = memeWebModelFromJson(jsonString);

import 'dart:convert';

MemeWebModel memeWebModelFromJson(String str) => MemeWebModel.fromJson(json.decode(str));

String memeWebModelToJson(MemeWebModel data) => json.encode(data.toJson());

class MemeWebModel {
  bool success;
  List<Datum> data;

  MemeWebModel({
    this.success,
    this.data,
  });

  factory MemeWebModel.fromJson(Map<dynamic, dynamic> json) => MemeWebModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String thumbnail;
  String mediaUrl;

  Datum({
    this.thumbnail,
    this.mediaUrl,
  });

  factory Datum.fromJson(Map<dynamic, dynamic> json) => Datum(
    thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
    mediaUrl: json["media_url"] == null ? null : json["media_url"],
  );

  Map<String, dynamic> toJson() => {
    "thumbnail": thumbnail == null ? null : thumbnail,
    "media_url": mediaUrl == null ? null : mediaUrl,
  };
}
