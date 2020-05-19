import 'package:bloc_provider/bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/common/constanst/route_constants.dart';
import 'package:whatsup/module/dummy_screen.dart';
import 'package:whatsup/module/widget/user_status_widget.dart';
import 'package:whatsup/utils/user_manager.dart';
import '../../../../common/const.dart';
import '../../../../model/post_model.dart';
import '../../../../module/post_content/bloc/post_bloc.dart';
import '../../../../module/widget/follow_widget.dart';
import '../../../../module/widget/unfollow_widget.dart';
import '../../../../presentation/theme/theme_text.dart';

class PostHeaderScreen extends StatefulWidget {
  final Size size;
  final PostModel post;

  PostHeaderScreen(this.size, this.post);

  @override
  _PostHeaderScreenState createState() => _PostHeaderScreenState();
}

class _PostHeaderScreenState extends State<PostHeaderScreen> {
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PostModel>(
        stream: _postBloc.postStream,
        initialData: widget.post,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: number_20),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: widget.post.owner.avatarPhotoUrl == ''
                          ? AssetImage('assets/images/avatar_empty.png')
                          : CachedNetworkImageProvider(
                              widget.post.owner.avatarPhotoUrl),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: number_10),
                      child: Text(
                        widget.post.owner.username ?? '',
                        style: ThemeText.textStyleNormalWhite15,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: number_15),
                child: StreamBuilder<bool>(
                    stream: _postBloc.followController,
                    initialData: widget.post.owner.followedByViewer,
                    builder: (context, snapshot) {
//                      print('CURRENT USER: ${UserManager.instance.currentUser}');
                      return UserStatusWidget(
                        currentRoute: RouteList.featuredPost,
                        builder: (c, status) {
                          /// nếu user đã login rồi thì mới
                          /// check theo logic đúng
                          if (status == UserStatus.loggedIn) {
                            return widget.post.owner.followedByViewer
                                ? FollowWidget(widget.post)
                                : UnFollowWidget(widget.post);
                          } else {
                            /// còn nếu chưa cap nhat profile
                            /// hoac chưa login thì
                            /// cứ hiện UI giả như chưa đăng kí
                            /// UI này ko chứa inkwell hay Gesture nha
                            /// vì nó sẽ đè lên cái sự kiện
                            /// bắt trong UserWidget
                            return Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(number_20),
                                    border: Border.all(color: Colors.white)),
                                child: Padding(
                                    padding: const EdgeInsets.all(number_10),
                                    child: Text('ĐĂNG KÍ',
                                        style: ThemeText.textStyleSubsYes15)));
                          }
                        },
                      );
                    }),
              ),
            ],
          );
        });
  }
}
