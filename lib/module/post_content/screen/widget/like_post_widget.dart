import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsup/common/const.dart';
import 'package:whatsup/common/constanst/icon_constants.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';
import 'package:whatsup/module/widget/user_status_widget.dart';
import 'package:whatsup/presentation/theme/theme_text.dart';
import 'package:whatsup/utils/number_utils.dart';
import 'package:whatsup/utils/user_manager.dart';

class LikePostWidget extends StatefulWidget {
  final PostModel post;

  LikePostWidget(this.post);

  @override
  _LikePostWidgetState createState() => _LikePostWidgetState();
}

class _LikePostWidgetState extends State<LikePostWidget> {
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _postBloc.likeStream,
        initialData: widget.post.viewerHasLiked,
        builder: (context, snapshot) {
          bool isLike = widget.post.viewerHasLiked;
          return UserStatusWidget(
            currentRoute: RouteList.featuredPost,
            builder: (c,status) {
              if (status == UserStatus.loggedIn) {
                return InkWell(
                  onTap: () {
                    _postBloc.doLike(widget.post, UserManager.instance.currentUser);
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(IconConstants.iconLikePath,
                          color: isLike
                              ? Colors.blue
                              : Colors.white,
                          semanticsLabel: 'Like'),
                      Padding(
                        padding: const EdgeInsets.only(left: number_3),
                        child: Text(
                          NumberUtils.handleNumber(widget.post.likeCount),
                          style: ThemeText.textStyleNormalWhite15,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Row(
                  children: <Widget>[
                    SvgPicture.asset(IconConstants.iconLikePath,
                        color: Colors.white,
                        semanticsLabel: 'Like'),
                    Padding(
                      padding: const EdgeInsets.only(left: number_3),
                      child: Text(
                        NumberUtils.handleNumber(widget.post.likeCount),
                        style: ThemeText.textStyleNormalWhite15,
                      ),
                    )
                  ],
                );
              }
            },

          );
        });
  }
}
