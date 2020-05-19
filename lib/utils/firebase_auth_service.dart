import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart';
import 'firebase_database_service.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// ignore: prefer_generic_function_type_aliases
//typedef void LoginGoogleResult(bool isExisting, UserModel user);

class LoginSocialResult {
  LoginSocialResult({this.isExisting,this.user});
  bool isExisting;
  UserModel user;
}


class WhatsupAuthService {
  static final WhatsupAuthService instance = WhatsupAuthService();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebooklogin = FacebookLogin();

  Future<FirebaseUser> getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    return user;
  }

  void logout() {
    _googleSignIn.signOut();
    _auth.signOut();
    _facebooklogin.logOut();
  }

  /// throw nếu có lỗi
  /// trả về null tức là bị gì đó
  /// trả về != null là login OK
  Future<UserModel> loginWithEmailAndPassword(
      {String email, String password}) async {
    const errorDefault = 'Login thất bại';
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // lấy data user này về
        final data =
            await WhatsUpDBService.instance.getUserInfo(result.user.uid);

        if (data != null) {
          final user = UserModel.fromJson(data);
          // ignore: cascade_invocations
          user.id = result.user.uid;
          return user;
        }

        throw errorDefault;
      } else {
        throw errorDefault;
      }
    } catch (e) {
      if (e is PlatformException) {
        throw FirebaseAuthErrorCode.getErrorDetails(e.code);
      } else {
        throw errorDefault;
      }
    }
  }

  /// throw hoặc false là có lỗi
  /// trả về true tức là gởi OK
  Future<void> sendRecoveryEmail(
      {String email}) async {
    const errorDefault = 'Có lỗi xảy ra. Vui lòng thử lại sau!';
    try {
      await _auth.sendPasswordResetEmail(
        email: email
      );
      return;
    } catch (e) {
      if (e is PlatformException) {
        throw FirebaseAuthErrorCode.getErrorDetails(e.code);
      } else {
        throw errorDefault;
      }
    }
  }

  /// throw nếu có lỗi
  /// trả về null tức là bị gì đó
  /// trả về != null là login OK
  Future<UserModel> loginWithPhone(
      {String phone,String otp,String authId}) async {
    const errorDefault = 'Login thất bại';
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: authId,
        smsCode: otp,
      );

      final result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        // lấy data user này về
        final data =
        await WhatsUpDBService.instance.getUserInfo(result.user.uid);

        if (data != null) { // có rồi thì trả ra
          final user = UserModel.fromJson(data)
          ..id = result.user.uid;
          return user;
        } else { // chưa có thì tạo mới tren DB
          final user = UserModel()
            ..id = result.user.uid
          ..phoneNumber = phone;

          await WhatsUpDBService.instance.updateUser(user);

          return user;
        }
      } else {
        throw errorDefault;
      }
    } catch (e) {
      if (e is PlatformException) {
        throw FirebaseAuthErrorCode.getErrorDetails(e.code);
      } else {
        throw errorDefault;
      }
    }
  }

  /// throw nếu có lỗi
  /// trả về null tức là bị gì đó
  /// trả về != null là login OK
  Future<UserModel> createAccountUsingEmailPassword(
      {String email, String password}) async {
    const errorDefault = 'Đăng ký tài khoản thất bại';
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        final fbUser = result.user;
        var user = UserModel()..id = fbUser.uid
        ..email = email;

        // đồng thời tạo user trên DB
        await WhatsUpDBService.instance.updateUser(user);

        return user;
      } else {
        throw errorDefault;
      }
    } catch (e) {
      if (e is PlatformException) {
        throw FirebaseAuthErrorCode.getErrorDetails(e.code);
      } else {
        throw errorDefault;
      }
    }
  }



  /// throw nếu có lỗi
  /// trả về null tức là bị gì đó
  /// trả về != null là login OK
  Future<LoginSocialResult> loginGoogle() async {
    const errorDefault = 'Login thất bại';
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        debugPrint(result.user.uid);
        // lấy data user này về
        final data =
        await WhatsUpDBService.instance.getUserInfo(result.user.uid);

        if (data != null) { // có rồi thì trả ra
          final user = UserModel.fromJson(data)
            ..id = result.user.uid;
          return LoginSocialResult(isExisting: true,user: user);
        } else { // chưa có thì tạo mới tren DB
          final user = UserModel()
            ..id = result.user.uid;

          await WhatsUpDBService.instance.updateUser(user);

          return LoginSocialResult(isExisting: false,user: user);
        }
      } else {
        throw errorDefault;
      }
    } catch (e) {
      if (e is PlatformException) {
        throw FirebaseAuthErrorCode.getErrorDetails(e.code);
      } else {
        throw errorDefault;
      }
    }
  }

  /// throw nếu có lỗi
  /// trả về null tức là bị gì đó
  /// trả về != null là login OK
  Future<LoginSocialResult> loginFacebook() async {
    const errorDefault = 'Login facebook thất bại';
    try {
      await _facebooklogin.logOut();
      final FacebookLoginResult fbLoginResult =
      await _facebooklogin.logIn(['email']);
      if (fbLoginResult.status == FacebookLoginStatus.loggedIn) {
        final credential = FacebookAuthProvider.getCredential(
          accessToken: fbLoginResult.accessToken.token,
        );

        final result = await _auth.signInWithCredential(credential);

        if (result.user != null) {
          debugPrint(result.user.uid);
          // lấy data user này về
          final data =
          await WhatsUpDBService.instance.getUserInfo(result.user.uid);

          if (data != null) { // có rồi thì trả ra
            final user = UserModel.fromJson(data)
              ..id = result.user.uid;
            return LoginSocialResult(isExisting: true, user: user);
          } else { // chưa có thì tạo mới tren DB
            final user = UserModel()
              ..id = result.user.uid;

            await WhatsUpDBService.instance.updateUser(user);

            return LoginSocialResult(isExisting: false, user: user);
          }
        }
      }
      throw errorDefault;
    } catch (e) {
      if (e is PlatformException) {
        throw FirebaseAuthErrorCode.getErrorDetails(e.code);
      } else {
        throw errorDefault;
      }
    }
  }



  Future<void> sendCodeToPhoneNumber(String phone) async {
    final Completer<String> c =  Completer();
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {

      c.completeError('Phone number verification failed. '
          'Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {

      debugPrint("code sent to $phone" );
      c.complete(verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        c.complete;

     await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

    return c.future;
  }

  /// true là tồn tại và ngược lại
  Future<bool> checkEmailUserExist({String email}) async {
    const errorDefault = 'Không thể kiểm tra user. Vui lòng thử lại sau!';
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        // gởi pass random để làm mồi check tồn tại
        password: '9Hg5?de2_h>tM7Y9',
      );
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == FirebaseAuthErrorCode.ERROR_USER_NOT_FOUND) {
          return false;
        } else if (e.code == FirebaseAuthErrorCode.ERROR_WRONG_PASSWORD) {
          // sai pass nghĩa là đăng kí rồi
          return true;
        } else {
          throw FirebaseAuthErrorCode.getErrorDetails(e.code);
        }
      } else {
        throw errorDefault;
      }
    }
  }
}

class FirebaseAuthErrorCode {
  static const ERROR_INVALID_EMAIL = "ERROR_INVALID_EMAIL";
  static const ERROR_WRONG_PASSWORD = "ERROR_WRONG_PASSWORD";
  static const ERROR_USER_NOT_FOUND = "ERROR_USER_NOT_FOUND";
  static const ERROR_USER_DISABLED = "ERROR_USER_DISABLED";
  static const ERROR_TOO_MANY_REQUESTS = "ERROR_TOO_MANY_REQUESTS";
  static const ERROR_OPERATION_NOT_ALLOWED = "ERROR_OPERATION_NOT_ALLOWED";
  static const ERROR_WEAK_PASSWORD = "ERROR_WEAK_PASSWORD";
  static const ERROR_EMAIL_ALREADY_IN_USE = "ERROR_EMAIL_ALREADY_IN_USE";
  static const ERROR_INVALID_ACTION_CODE = "ERROR_INVALID_ACTION_CODE";

  static String getErrorDetails(String code) {
    switch (code) {
      case FirebaseAuthErrorCode.ERROR_INVALID_EMAIL:
        return 'Email không đúng định dạng';

      case FirebaseAuthErrorCode.ERROR_WRONG_PASSWORD:
        return 'Mật khẩu không chính xác';

      case FirebaseAuthErrorCode.ERROR_USER_NOT_FOUND:
        return 'Không tìm thấy người dùng';

      case FirebaseAuthErrorCode.ERROR_INVALID_ACTION_CODE:
        return 'Mã OTP không chính xác';

      case FirebaseAuthErrorCode.ERROR_USER_DISABLED:
        return 'Người dùng này không còn hiệu lực';

      case FirebaseAuthErrorCode.ERROR_TOO_MANY_REQUESTS:
        return 'Bạn đã đăng nhập vào người dùng quá nhiều lần! '
            'Vui lòng thử lại sau';

      case FirebaseAuthErrorCode.ERROR_OPERATION_NOT_ALLOWED:
        return 'Máy chủ không cấp phép đăng nhập bằng phương thức này';

      case FirebaseAuthErrorCode.ERROR_WEAK_PASSWORD:
        return 'Mật khẩu quá yếu, vui lòng chọn mật khẩu khác';

      case FirebaseAuthErrorCode.ERROR_EMAIL_ALREADY_IN_USE:
        return 'Email này đã đăng ký rồi';

      default:
        return 'Đã xảy ra lỗi! Vui lỏng thử lại';
    }
  }
}
