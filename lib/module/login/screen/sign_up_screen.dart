import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/common/extensions/string_extension.dart';
import 'package:whatsup/utils/user_manager.dart';

import '../../../utils/firebase_auth_service.dart';
// ignore: directives_ordering
import '../../../utils/firebase_database_service.dart';
import '../../../utils/life_cycle/lifecycle.dart';
import '../../../utils/validation_utils.dart';
import '../../../utils/widgets/w_text_widget.dart';
// ignore: directives_ordering
import '../../../utils/life_cycle/base.dart';


class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseState<SignUpScreen> {
  final TextEditingController _controller = TextEditingController();

  bool _isFloatingButtonActive = false;
  bool _isLoading = false;
  String _errorText;
  /*
      Cái này để ví dụ đang nhập email ở tab
       email click qua tab nhập số điện thoại clear input feild.
      Rồi người dùng click vào tab email thì đổ email cũ vào input field
   */
  String _phoneMemory;
  String _emailMemory;

  bool _isEmail = false;

  @override
  void initState() {
    //Active floating button
    _controller.addListener( () {
      setState((){
        _isFloatingButtonActive = _controller.text.isNotEmpty;
        _errorText = null;
      });
    } );
    super.initState();
  //  _controller.text = "test001@gmail.com";
  //  _bloc = getCurrentBloc<SignInBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xff242A37),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const WText('Đăng ký',fontWeight: FontWeight.w500,
          color: Colors.white,),

//Bỏ Nút tiếp trên App Bar
//        actions: <Widget>[
//          InkWell(
//            onTap: _nextButtonClick,
//              child: const Padding(
//                padding: EdgeInsets.symmetric(horizontal: 20),
//                child: Center(child: WText("Tiếp",
//                  fontWeight: FontWeight.bold,color:
//                  Colors.white,
//                  size: 15,
//                )
//                ),
//              )
//          )
//        ],
          leading : InkWell(
            onTap: goBack,
            child: Icon(
            Icons.arrow_back
            ),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildButton('Số điện thoại',
                    !_isEmail ? const Color(0xff6D6F77)
                        : const  Color(0xff242A37),
                        () {
                      setState(() {
                        if(_isEmail) {
                          _emailMemory = _controller.text;
                        }
                        _setTextWithCursorAtTheEnd(_phoneMemory);
                        _isEmail = false;
                      });
                    }),
                const SizedBox(width: 10), //Cach ra một chút
                _buildButton('Email',
                    _isEmail ? const Color(0xff6D6F77)
                        : const Color(0xff242A37),
                        () {
                      setState(() {
                        if(!_isEmail) {
                          _phoneMemory = _controller.text;
                        }
                        _setTextWithCursorAtTheEnd(_emailMemory);
                        _isEmail = true;
                      });
                    }),
              ],
            ),

            TextFormField(
              controller: _controller,
                keyboardType: !_isEmail ? TextInputType.number
                    : TextInputType.text ,
                style: const TextStyle(
                  color: Colors.white
                ),
                decoration: InputDecoration(
                    errorText: _errorText, //thêm Error text để show error
                    hintText: _isEmail ? 'Địa chỉ email' : 'Số điện thoại',
                    hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey
                    ),
                    //Thêm nút clear
                    suffixIcon: _isFloatingButtonActive ? IconButton(
                      onPressed: _controller.clear,
                      icon: Icon(Icons.clear),
                    ) : null
                )
            ),

            const SizedBox(height: 16,),

            const WText(
              'Thông qua việc tiếp tục, bạn cho biết bạn đồng ý với điều khoản '
                  'sử dụng của Whatsup và xác nhận rằng bạn đã đọc Chính '
                  'sách Quyền riêng tư của Whatsup.',
              size: 15,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  this.hideKeyboard();
                },
              ) ,
            )

          ],
        ),
      ),

        //Thêm Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: _isFloatingButtonActive ? _nextButtonClick : null,
        backgroundColor: _isFloatingButtonActive
            ? const Color(0xffFF9500) : Colors.grey,

        child: _isLoading ? const CircularProgressIndicator(
          valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
        ) :
        Icon(Icons.arrow_forward),
      )
    );
  }

  Widget _buildButton(String title, Color color, Function click) {
    return RaisedButton(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onPressed: () {
        this.hideKeyboard();
        click();
      },
      child: Container(
        alignment: Alignment.center,
        width: 120,
        child: WText(
            title,
          size: 16,
        ),
      ),
    );
  }
  void _nextButtonClick() {
    if (_controller.text.isEmpty) {
//      showSimpleDialog(title : "Chú ý",
//          message:  "Vui lòng nhập ${_isEmail ?
//          "email" : "số điện thoại"}");
//      return ;
      setState(() {
        _errorText = "Vui lòng nhập ${_isEmail ? "email" : "số điện thoại"}";
      });
      return;
    }

    if (_isEmail) {
      if (!ValidationUtils.isValidEmail(_controller.text)) {
        setState(() {
          _errorText = 'Vui lòng nhập email hợp lệ';
        });
        return;
      }
    } else {
      if (!ValidationUtils.isValidPhoneNumber(_controller.text)) {
        setState(() {
          _errorText = 'Vui lòng nhập sô điện thoại hợp lệ';
        });
        return;
      }
    }

    if (_isEmail) {
//      showLoading();
//    Đổi loading, sang loading ở floating button
      _showLoading();
      WhatsupAuthService.instance.
      checkEmailUserExist(email: _controller.text)
          .then((isExsiting) {
        _hideLoading();
        pushScreen(routerName: RouteList.loginInputPass,
            param: [_controller.text,!isExsiting,false ] );
      },onError: (err) {
        _hideLoading();
        showSimpleDialog(title: 'Lỗi',message: err.toString());
      });
    } else {
      _showLoading();
      final finalPhone = _controller.text.toPhoneWithCountryCode();
      WhatsupAuthService.instance.
      sendCodeToPhoneNumber(finalPhone)
          .then((authId) {
        // call tiep coi co acc nao dung SDt nay chua
        WhatsUpDBService.instance.checkPhoneExist
          (finalPhone).then((isExist) {
          _hideLoading();
          pushScreen(routerName: RouteList.loginInputPass,
              param: [finalPhone,!isExist,true,authId]);
        },onError: (err) {
          _hideLoading();
          showSimpleDialog(title: 'Lỗi',message: err.toString());
        });
      },onError: (err) {
        _hideLoading();
        showSimpleDialog(title: 'Lỗi',message: err.toString());
      });

    }
  }

  void _setTextWithCursorAtTheEnd(String text){
    //Nếu dùng _controller.text = text thì cursor sẽ dừng ở bắt đầu
    _controller.text = text;
    text != null ? _controller.selection =
        TextSelection.fromPosition(TextPosition(offset: text.length)) : null;
  }

  void _showLoading(){
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading(){
    setState(() {
      _isLoading = false;
    });
  }


}
