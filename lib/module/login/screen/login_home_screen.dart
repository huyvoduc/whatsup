import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import '../../../common/constanst/icon_constants.dart';
import '../../../common/constanst/image_constants.dart';
import '../../../utils/firebase_auth_service.dart';
import '../../../utils/firebase_auth_service.dart';
import '../../../utils/firebase_database_service.dart';
import '../../../utils/user_manager.dart';
import '../../../utils/widgets/w_text_widget.dart';
import 'sign_up_screen.dart';

// ignore: directives_ordering
import '../../../utils/life_cycle/base.dart';

class LoginScreen extends StatefulWidget {
  static Widget newInstance() {
//    return BlocProvider<LoginBloc>(
//      creator: (_context, _bag) => LoginBloc(),
//      child: LoginScreen(),
//    );

    return LoginScreen();
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  // LoginBloc _bloc;

  @override
  void initState() {
    // _bloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242A37),
      body: Stack(
        children: <Widget>[
          Center(
            child:
            //Đăng nhập Whatsup để tiếp tục
            Padding(
              padding: const EdgeInsets.all(20),
              child: WText('Đăng nhập Whatsup để tiếp tục',size: 20,
                textAlign: TextAlign.center,
                color: Colors.white,),
            )


          ),

          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    pushScreen(routerName:
                    RouteList.loginSignUp);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    decoration:  BoxDecoration(
                        border: Border.all(width: 1,color: Colors.white),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(25))
                    ),
                    alignment: Alignment.center,
                    child: Text('Số điện thoại hoặc email',
                      style: TextStyle(color : Colors.white),),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: _loginFacebook,
                      child: Image.asset(IconConstants.iconFB,
                      height: 50,width: 50,),
                    ),
                    const SizedBox(width: 20,),
                    InkWell(
                      onTap: _loginGoogle,
                      child: Image.asset(IconConstants.iconGoogle,
                        height: 50,width: 50,),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _loginFacebook() {
    showLoading();

    WhatsupAuthService.instance.loginFacebook()
        .then((result) {
      hideLoading();
      _processLoginResult(result);
    },onError: (err) {
      hideLoading();
      showSimpleDialog(title: 'Lỗi',
          message: err.toString());
    });
  }

  void _processLoginResult(LoginSocialResult result) {
    if(result.isExisting) {
      UserManager.instance.
      updateUserAfterLogin(result.user);
      popToRoute(route: UserManager.instance
          .loginAtScreen);
      UserManager.instance.loginAtScreen = '';
    } else {
      UserManager.instance.
      updateUserAfterLogin(result.user,isNotify: false);
      pushScreen(routerName: RouteList.
      loginInputBirthDay,param: result.user);
    }
  }

  void _loginGoogle() {
    showLoading();
    WhatsupAuthService.instance.loginGoogle()
        .then((result) {
      hideLoading();
      _processLoginResult(result);
    },onError: (err) {
      hideLoading();
      showSimpleDialog(title: 'Lỗi',
          message: err.toString());
    });
  }
}
