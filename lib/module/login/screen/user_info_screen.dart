import 'package:flutter/material.dart';
import '../../../presentation/theme/theme_color.dart';
import '../../../utils/firebase_database_service.dart';
import '../../../utils/life_cycle/base.dart';
import '../../../utils/user_manager.dart';
import '../../../utils/widgets/w_text_widget.dart';
import '../../../utils/widgets/w_textfield_widget.dart';
// ignore: directives_ordering
import '../../../model/user_model.dart';

// ignore: avoid_classes_with_only_static_members
enum GenderType {
  male,
  female }

extension GenterTypeEx on GenderType {
  String getDisplayGender() {
    switch (this) {
      case GenderType.male:
        return 'Nam';
      case GenderType.female:
        return 'Nữ';
    }
    return '';
  }

  String getValueGender() {
    switch (this) {
      case GenderType.male:
        return 'M';
      case GenderType.female:
        return 'F';
    }
    return '';
  }
}

// ignore: must_be_immutable
class RegisterUserInfoScreen extends StatefulWidget {


  @override
  _RegisterUserInfoScreenState createState() => _RegisterUserInfoScreenState();
}

class _RegisterUserInfoScreenState extends BaseState<RegisterUserInfoScreen> {
  bool _isFloatingButtonActive = false;
  bool _isLoading = false;
  String _errorNameText;
  String _errorUserNameText;
  UserModel user;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  GenderType _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_textEditingListener);
    _userNameController.addListener(_textEditingListener);
    Future.delayed(const Duration(milliseconds: 100) , () {
      final UserModel param = getRouteParam();
      setState(() {
        user = param;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff242A37),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: WText(
              'Đăng ký',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            actions: <Widget>[
              InkWell(
                  onTap: _nextButtonClick,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                        child: WText(
                      'Hoàn tất',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      size: 15,
                    )),
                  ))
            ],
            leading: InkWell(
              onTap: goBack,
              child: Icon(Icons.arrow_back),
            )),
        body: _buildContent(),
        floatingActionButton: FloatingActionButton(
          onPressed: _isFloatingButtonActive ? _nextButtonClick : null,
          backgroundColor: _isFloatingButtonActive
              ? const Color(0xffFF9500)
              : Colors.grey,
          child: _isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Icon(Icons.check),
        ));
  }

  ///

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          WText(
            'Chỉ còn một bước nữa',
            fontWeight: FontWeight.w600,
            size: 20,
            color: Colors.white,
          ),

          const SizedBox(height: 10),

          const WText('Bạn có thể đổi tên hoặc username bất kỳ lúc nào.'),

          const SizedBox(height: 10),

          /// họ tên
          WTextField(
            _nameController,
            hintText: 'Họ tên',
            errorText: _errorNameText,
          ),

          /// user name
          WTextField(
            _userNameController,
            hintText: 'User name',
            errorText: _errorUserNameText,
          ),

          const SizedBox(height: 8),

          /// chọn gender
          InkWell(
            onTap: () {
              Widget buildItem(String title, Function action) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    action();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: WText(
                      title,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                );
              }

              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (bc) {
                    return Container(
                      height: 100,
                      color: Colors.white,
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          buildItem(GenderType.male.getDisplayGender(), () {
                            setState(() {
                              _selectedGender = GenderType.male;
                            });
                          }),
                          buildItem(GenderType.female.getDisplayGender(), () {
                            setState(() {
                              _selectedGender = GenderType.female;
                            });
                          }),
                        ],
                      ),
                    );
                  });
            },
            child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              child: WText(_selectedGender?.getDisplayGender() ?? 'Giới tính',
                  size: 15,
                  color: _selectedGender == null
                      ? AppColor.defaultTextColor
                      : Colors.white),
            ),
          ),

          const SizedBox(height: 8),

          // bottom line
          Container(
            height: 1,
            width: double.infinity,
            color: AppColor.lineTextColor,
          ),
        ],
      ),
    );
  }

  Future<void> _nextButtonClick() async {
    if (_nameController.text.isEmpty) {
//      showSimpleDialog(title : "Chú ý",
//          message:  "Vui lòng nhập họ tên của bạn");
      setState(() {
        _errorNameText = 'Vui lòng nhập họ tên của bạn';
      });
      return;
    }
    if (_userNameController.text.isEmpty) {
//      showSimpleDialog(title : "Chú ý",
//          message:  "Vui lòng nhập user name của bạn");
      setState(() {
        _errorUserNameText = 'Vui lòng nhập user name của bạn';
      });
      return;
    }
    if (_selectedGender == null) {
      showSimpleDialog(
          title: 'Chú ý', message: 'Vui lòng chọn giới tính của bạn');
      return;
    }
    _showLoading();
    //Thêm check username exist
    final userNameExist = await WhatsUpDBService.instance
        .checkUserNameExist(_userNameController.text);
    if (userNameExist) {
      _hideLoading();
      setState(() {
        _errorUserNameText = 'Username đã tồn tại';
      });
    } else {
      final user = this.user
        ..fullName = _nameController.text
        ..username = _userNameController.text
        ..gender = _selectedGender;

      await WhatsUpDBService.instance.updateUser(user).then((_) {
        _hideLoading();
        UserManager.instance.updateUserAfterLogin(user);
        popToRoute(route: UserManager.instance.loginAtScreen);
        UserManager.instance.loginAtScreen = '';
      }, onError: (e) {
        _hideLoading();
        showSimpleDialog(title: 'Lỗi', message: e.toString());
      });
    }
  }

  void _textEditingListener() {
    setState(() {
      _isFloatingButtonActive =
          _nameController.text.isNotEmpty
              && _userNameController.text.isNotEmpty;
      _errorUserNameText = null;
      _errorNameText = null;
    });
  }

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }
}
