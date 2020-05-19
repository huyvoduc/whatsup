
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/utils/validation_utils.dart';
// ignore: directives_ordering
import '../../../utils/firebase_auth_service.dart';
// ignore: directives_ordering
import '../../../utils/firebase_database_service.dart';
import '../../../utils/user_manager.dart';
import '../../../utils/widgets/w_text_widget.dart';
// ignore: directives_ordering
import '../../../utils/life_cycle/base.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends BaseState<ResetPasswordScreen> {
  final TextEditingController _controller = TextEditingController();


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
  }

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      backgroundColor: const Color(0xff242A37),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: WText( 'Quên mật khẩu',
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

            TextFormField(
                controller: _controller,
                style: const TextStyle(
                    color: Colors.white
                ),
                decoration: InputDecoration(
                    errorText: _errorText,
                    hintText: 'Địa chỉ email',
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

            const SizedBox(height: 10),

            const WText(
              'Chúng tôi sẽ gửi hướng dẫn lấy lại mật khẩu vào email của bạn.',
              size: 15,
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isFloatingButtonActive ? _nextButtonClick : null,
        backgroundColor: _isFloatingButtonActive ?
        const Color(0xffFF9500) : Colors.grey,

        child: _isLoading ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ) : Icon(Icons.check),
      ),
    );
  }///


  void _nextButtonClick(){
    {
      final email = _controller.text.trim();
      if (email.isEmpty) {
        setState(() {
          _errorText = 'Vui lòng nhập email';
        });
        return ;
      }

      if (!ValidationUtils.isValidEmail(email)) {
        setState(() {
          _errorText = 'Vui lòng nhập email hợp lệ';
        });
        return;
      }

      _showLoading();
      WhatsupAuthService.instance.
      sendRecoveryEmail(email : email)
          .then((user) async {
        setState(() {
          _isLoading = false;
        });
        // ignore: lines_longer_than_80_chars
        await showSimpleDialog(
          title: 'Lưu ý',
            message: 'Chúng tôi đã gửi một liên kết vào địa chỉ '
                'email $email. Vui lòng làm theo hướng dẫn trong email để'
                ' lấy lại mật khẩu');
        goBack();
      }, onError: (err) {
        setState(() {
          _isLoading = false;
          _errorText = err.toString();
        });
        //showSimpleDialog(title: "Lỗi", message: err.toString());
      });
    }
  }
  void _showLoading(){
    setState(() {
      _isLoading = true;
    });
  }


}
