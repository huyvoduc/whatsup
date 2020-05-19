import 'dart:convert';

import '../module/login/screen/user_info_screen.dart';

// ignore: directives_ordering
import '../common/extensions/datetime_extension.dart';
import 'base_model.dart';



const String colAvatarPhotoUrl = 'avatar_photo_url';
const String colUsername = 'username';
const String colBio = 'bio';
const String colBirthDay = 'birth_day';
const String colCoverPhotoUrl = 'cover_photo_url';
const String colEmail = 'email';
const String colEmailVerified = 'email_verified';
const String colFullName = 'full_name';
const String colGender = 'gender';
const String colPhoneNumber = 'phone_number';

/// extra value from api
const String apiFollowedByViewer = 'followed_by_viewer';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends BaseModel {
  String username = '';
  String fullName = '';
  String email = '';

  String phoneNumber = '';
  String bio = '';
  int birthDay = 0;
  GenderType gender;
  String coverPhotoUrl = '';
  String avatarPhotoUrl = '';


  ///extra value from api
  bool followedByViewer = false;

  UserModel({
    id,
    this.username,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.bio,
    this.birthDay,
    this.gender,
    this.coverPhotoUrl,
    this.avatarPhotoUrl,
  }): super(id: id);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json['username'] ?? '',
        fullName: json['full_name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        bio: json['bio'] ?? '',
        birthDay: json['birth_day'] ?? 0,
        gender: json['gender'] != null
            ? json['gender'] == GenderType.male.getValueGender()
                ? GenderType.male
                : GenderType.female
            : null,
        coverPhotoUrl: json['cover_photo_url'] ?? '',
        avatarPhotoUrl: json['avatar_photo_url'] ?? '',
      );
  factory UserModel.fromJsonDynamic(Map<dynamic, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    username: json['username'] ?? '',
    fullName: json['full_name'] ?? '',
    email: json['email'] ?? '',
    phoneNumber: json['phone_number'] ?? '',
    bio: json['bio'] ?? '',
    birthDay: json['birth_day'] ?? 0,
    gender: json['gender'] != null
        ? json['gender'] == GenderType.male.getValueGender()
        ? GenderType.male
        : GenderType.female
        : null,
    coverPhotoUrl: json['cover_photo_url'] ?? '',
    avatarPhotoUrl: json['avatar_photo_url'] ?? '',
  );

  String getDisplayBirthday() {
    return birthDay == 0
        ? ''
        : DateTime.fromMillisecondsSinceEpoch(birthDay).toBirthDayString();
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'bio': bio,
        'birth_day': birthDay,
        'gender': gender != null ? gender.getValueGender() : '',
        'cover_photo_url': coverPhotoUrl,
        'avatar_photo_url': avatarPhotoUrl,
      };
}
