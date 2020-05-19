import 'package:flutter/material.dart';

import 'package:whatsup/common/widgets/circle_image.dart';
import 'package:whatsup/common/widgets/simple_button.dart';
import 'package:whatsup/common/widgets/simple_icon_button.dart';
import 'package:whatsup/module/profile/edit_profile/change_value_screen.dart';
import 'package:whatsup/module/profile/models/user.dart';
import 'package:whatsup/utils/dimension.dart';

import '__mock__/mock_data_profile.dart';

class EditPersonalInfomationScreen extends StatefulWidget {
  @override
  _EditPersonalInfomationScreenState createState() =>
      _EditPersonalInfomationScreenState();
}

class _EditPersonalInfomationScreenState
    extends State<EditPersonalInfomationScreen> {
  final double headerHeight = Dimension.getHeight(0.5);
  final double avatarsize = Dimension.getHeight(0.2);

  //theme
  ThemeData _themeData;
  TextTheme get _textTheme => _themeData.textTheme;
  User user;
  @override
  void initState() {
    user = userMock;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: _themeData.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildPersonalInfomation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: Dimension.getHeight(0.5),
      width: Dimension.width,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Image.asset(
                  user.cover,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              const Expanded(
                flex: 2,
                child: SizedBox(),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: Dimension.statusBarHeight,
                ),
                child: _buildAppbar(),
              ),
              _buildAvatar(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAppbar() {
    const double iconSize = 50;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SimpleIconButton(
          height: iconSize,
          width: iconSize,
          icon: Icon(
            Icons.arrow_back,
            color: _themeData.accentColor,
          ),
          borderColor: Colors.transparent,
          borderRadius: 0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            SimpleButton(
              height: 20,
              width: 60,
              text: 'Save',
              textStyle: _textTheme.title.copyWith(
                color: _themeData.accentColor,
              ),
              borderColor: Colors.transparent,
              borderRadius: 0,
              bgColors: const [Colors.transparent, Colors.transparent],
              onPressed: () {},
            ),
            SimpleIconButton(
              height: iconSize,
              width: iconSize,
              icon: Icon(
                Icons.edit,
                color: _themeData.accentColor,
              ),
              borderColor: Colors.transparent,
              borderRadius: 0,
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: <Widget>[
        CircleImage(
          image: Image.asset(
            user.avatar,
            fit: BoxFit.cover,
            width: avatarsize,
            height: avatarsize,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Đổi ảnh đại diện',
          style: _textTheme.subtitle.copyWith(
            color: Colors.blue,
          ),
        )
      ],
    );
  }

  Widget _buildPersonalInfomation() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        children: <Widget>[
          _buildPersonalItem(
            'Tên',
            user.name,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeValueScreen(
                    title: 'Đổi tên',
                    description:
                        '''Tên của bạn sẽ được hiển thị trong bài viết công khai''',
                    value: user.name,
                    hint: 'Tên của bạn...',
                    onSave: (value) async {
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        user.name = value;
                      });
                      return SaveResponse(
                        result: true,
                        message: 'Value has been changed!',
                        willPop: true,
                      );
                    },
                  );
                }),
              );
            },
          ),
          _buildPersonalItem(
            'Tên người dùng',
            '@${user.tag}',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeValueScreen(
                    title: 'Đổi tên người dùng',
                    description: 'Abc xyz',
                    value: user.tag,
                    hint: 'Nhập tên người dùng',
                    onSave: (value) async {
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        user.name = value;
                      });
                      return SaveResponse(
                        result: true,
                        message: 'Value has been changed!',
                        willPop: true,
                      );
                    },
                  );
                }),
              );
            },
          ),
          _buildPersonalItem(
            'Email',
            user.email,
          ),
          _buildPersonalItem(
            'Số điện thoại',
            user.phone,
          ),
          _buildPersonalItem(
            'Giới tính',
            user.gender,
          ),
          _buildPersonalItem(
            'Ngày sinh',
            user.birthday,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalItem(String title, String value, {Function onPressed}) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title ?? '',
            style: _textTheme.title.copyWith(
              color: Colors.white30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onPressed,
                child: Text(
                  value ?? '',
                  style: _textTheme.title.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
