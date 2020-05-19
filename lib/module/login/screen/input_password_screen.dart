import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
// ignore: directives_ordering
import '../../../utils/firebase_auth_service.dart';
// ignore: directives_ordering
import '../../../utils/firebase_database_service.dart';
import '../../../utils/user_manager.dart';
import '../../../utils/widgets/w_text_widget.dart';
// ignore: directives_ordering
import '../../../utils/life_cycle/base.dart';

class InputPasswordScreen extends StatefulWidget {
  @override
  _InputPasswordScreenState createState() => _InputPasswordScreenState();
}

class _InputPasswordScreenState extends BaseState<InputPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isRegister =false,isPhoneNumberFlow = true;
  String inputData = '';
  String authId = '';

  bool _isFloatingButtonActive = false;
  bool _isLoading = false;
  String _errorText;

  @override
  void initState() {
    super.initState();

    _controller.addListener( () {
      setState((){
        _isFloatingButtonActive = _controller.text.isNotEmpty ;
        _errorText = null;
      });
    });

    Future.delayed(const Duration(milliseconds: 100) , () {
      final param = getRouteParam();
      setState(() {
        inputData = param[0];
        isRegister = param[1];
        isPhoneNumberFlow = param[2];
        if (isPhoneNumberFlow) {
          authId = param[3];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      backgroundColor: const Color(0xff242A37),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: WText( isRegister ? 'Đăng ký' : 'Đăng nhập',
            fontWeight: FontWeight.w500,
            color: Colors.white,),

          leading : InkWell(
            onTap: goBack,
            child: Icon(
                Icons.arrow_back
            ),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WText(
            isPhoneNumberFlow ? 'Nhập mã gồm 6 chữ số' : 'Nhập mật khẩu',
              fontWeight: FontWeight.w600,
              size: 20,
              color: Colors.white,
            ),

            const SizedBox(height: 10),

            WText(
                // ignore: lines_longer_than_80_chars
              isPhoneNumberFlow ? 'Mã của bạn đã được gửi đến $inputData'
                // ignore: lines_longer_than_80_chars
                : isRegister ?  'Hãy nhập mật khẩu để đăng ký tài khoản.' :  '$inputData đã đăng ký. Hãy nhập mật khẩu để đăng nhập tài khoản.',
              size: 15,
            ),

            TextFormField(
                controller: _controller,
                obscureText : !isPhoneNumberFlow,
                keyboardType: isPhoneNumberFlow ? TextInputType.number
                    : TextInputType.text ,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: InputDecoration(
                    errorText: _errorText,
                    hintText: !isPhoneNumberFlow ? 'Mật khẩu' : 'OTP',
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

            const SizedBox(height: 20,),

            // nếu đăng nhập email thì hiện quên pass
            !isRegister && !isPhoneNumberFlow ?
                InkWell(
                  onTap: () {
                    pushScreen(routerName: RouteList.loginResetPass);
                  },
                  child: const WText( 'Quên mật khẩu',
                  color: Color(0xff0E77EA),
                    fontWeight: FontWeight.bold,
                  ),
                ) : Container()

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isFloatingButtonActive ? _nextButtonClick : null,
        backgroundColor: _isFloatingButtonActive ?
        const Color(0xffFF9500) : Colors.grey,

        child: _isLoading ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ) :
        isRegister ? Icon(Icons.arrow_forward) : Icon(Icons.check),
      ),
    );
  }///


  void _nextButtonClick(){
    {
      if (_controller.text.isEmpty) {
        setState(() {
          _errorText = isPhoneNumberFlow ? 'Vui lòng nhập OTP' :
          'Vui lòng nhập mật khẩu';
        });
        return ;
      }
      _showLoading();

      if (isPhoneNumberFlow) {
        hideLoading();
        WhatsupAuthService.instance.
        loginWithPhone(phone : inputData,
            otp: _controller.text.trim(),
            authId: authId)
            .then((user) {
          if (isRegister) {
            UserManager.instance.updateUserAfterLogin(user,isNotify: false);
            pushScreen(routerName: RouteList.loginInputBirthDay,param: user);
          } else {
            UserManager.instance.updateUserAfterLogin(user);
            popToRoute(route: UserManager.instance.loginAtScreen);
            UserManager.instance.loginAtScreen = '';
          }
        }, onError: (err) {
          setState(() {
            _isLoading = false;
            _errorText = err.toString();
          });
          //showSimpleDialog(title: "Lỗi", message: err.toString());
        });
      } else {
        if (isRegister) {
          // đăng ký
          _hideLoading();
          WhatsupAuthService.instance.
          createAccountUsingEmailPassword(email: inputData,
              password: _controller.text)
              .then((user) {
            UserManager.instance.updateUserAfterLogin(user,isNotify: false);
            pushScreen(routerName: RouteList.loginInputBirthDay,param: user);
          }, onError: (err) {
            setState(() {
              _isLoading = false;
              _errorText = err.toString();
            });
            //showSimpleDialog(title: "Lỗi", message: err.toString());
          });
        } else {
          // đăng nhập
          WhatsupAuthService.instance.
          loginWithEmailAndPassword(email: inputData,
              password: _controller.text)
              .then((user) {
            UserManager.instance.updateUserAfterLogin(user);
            popToRoute(route: UserManager.instance.loginAtScreen);
            UserManager.instance.loginAtScreen = '';
          },onError: (err) {
            setState(() {
              _isLoading = false;
              _errorText = err.toString();
            });
            //showSimpleDialog(title: "Lỗi",message: err.toString());
          });

        }
      }
    }
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
