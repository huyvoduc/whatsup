import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/user_manager.dart';
import '../../common/const.dart';
import '../../model/post_model.dart';
import '../../module/post_content/bloc/post_bloc.dart';
import '../../presentation/theme/theme_text.dart';
import 'user_status_widget.dart';

class FollowWidget extends StatefulWidget {
  final PostModel post;

  FollowWidget(this.post);

  @override
  _FollowWidgetState createState() => _FollowWidgetState();
}

class _FollowWidgetState extends BaseState<FollowWidget> {
  PostBloc _postBloc;

  @override
  void initState() {
    _postBloc = BlocProvider.of<PostBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(number_20),
            border: Border.all(color: Colors.white)),
        child: InkWell(
          child: Padding(
              padding: const EdgeInsets.all(number_10),
              child: Text('\u2713 ĐÃ ĐĂNG KÍ',
                  style: ThemeText.textStyleSubsYes15)),
          onTap: () {
            _postBloc.doSubscribe(widget.post, false);
          },
        )

//      InkWell(
//        onTap: () {
//          _postBloc.doSubscribe(widget.post);
//        },
//        child: Padding(
//            padding: const EdgeInsets.all(number_10),
//            child: Text('\u2713 ĐÃ ĐĂNG KÍ',
//                style: ThemeText.textStyleSubsYes15)),
//      ),
        );
  }
}
