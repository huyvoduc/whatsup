// To parse this JSON data, do
//
//     final albumModel = albumModelFromJson(jsonString);

import 'dart:convert';

List<AlbumModel> albumModelFromJson(String str) => List<AlbumModel>.from(json.decode(str).map((x) => AlbumModel.fromJson(x)));

String albumModelToJson(List<AlbumModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlbumModel {
  String type;
  String name;
  String thumbnail;

  AlbumModel({
    this.type,
    this.name,
    this.thumbnail,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
    type: json["type"] == null ? null : json["type"],
    name: json["name"] == null ? null : json["name"],
    thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "name": name == null ? null : name,
    "thumbnail": thumbnail == null ? null : thumbnail,
  };
}
