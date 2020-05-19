class User {
  String name;
  String avatar;
  String tag;
  String email;
  String cover;
  String phone;
  String gender;
  String birthday;

  User(
    this.name,
    this.avatar,
    this.tag, {
    this.email = '',
    this.cover = '',
    this.phone = '',
    this.gender = '',
    this.birthday = '',
  });
}
