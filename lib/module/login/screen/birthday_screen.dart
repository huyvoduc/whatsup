import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/model/user_model.dart';
import '../../../common/extensions/datetime_extension.dart';
import '../../../presentation/theme/theme_color.dart';
import '../../../utils/life_cycle/base.dart';
import '../../../utils/widgets/w_text_widget.dart';


// ignore: must_be_immutable
class BirthDayScreen extends StatefulWidget {

  @override
  _BirthDayScreenState createState() => _BirthDayScreenState();
}

class _BirthDayScreenState extends BaseState<BirthDayScreen> {
  UserModel user ;
  DateTime dob;

  @override
  void initState() {
    super.initState();
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
            bottomOpacity: 0,
            elevation: 0,
            title: WText(
              'Đăng ký',
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),

            //Đổi nút tiếp sang bỏ qua
            actions: <Widget>[
              InkWell(
                  onTap: () {
                    user.birthDay = 0;
                    pushScreen(routerName: RouteList.loginInputUserInfo,
                        param: user);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                        child: WText(
                      'Bỏ qua',
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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WText(
                'Ngày sinh của bạn là ngày nào?',
                fontWeight: FontWeight.w600,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              const WText(
                  'Ngày sinh của bạn sẽ không được hiển thị công khai.'),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  final now = DateTime.now();
                  DatePicker.showDatePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    setState(() {
                      dob = date;
                    });
                  },
                      currentTime:
                          DateTime.utc(now.year - 18, now.month, now.day),
                      maxTime: DateTime.now().toLocal(),
                      locale: LocaleType.vi);
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: WText(
                    dob != null ? dob.toBirthDayString() : 'Ngày sinh',
                    size: 15,
                    color: AppColor.defaultTextColor,
                  ),
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: AppColor.lineTextColor,
              )
            ],
          ),
        ),

        //Thêm Floating Button
        floatingActionButton: FloatingActionButton(
          onPressed: dob != null
              ? () {
            user.birthDay = dob.millisecondsSinceEpoch;
            pushScreen(routerName: RouteList.loginInputUserInfo,
                param: user);
          }
              : null,
          backgroundColor: dob == null ? Colors.grey : const Color(0xffFF9500),
          child: Icon(Icons.arrow_forward),
        ));
  }

///

}
