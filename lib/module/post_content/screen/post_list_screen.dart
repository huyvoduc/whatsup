import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:whatsup/dto/page_info_dto.dart';
import 'package:whatsup/dto/post_list_dto.dart';
import 'package:whatsup/utils/user_manager.dart';

import '../../../model/post_model.dart';
import '../../../module/post_content/bloc/post_bloc.dart';
import '../../../presentation/theme/theme_text.dart';
import '../../../utils/life_cycle/base.dart';
import '../../pending_screen.dart';
import 'post_item_screen.dart';

class PostScreen extends StatefulWidget {
  final PostListType postListType;

  PostScreen(this.postListType);

  static Widget newInstance(PostListType postListType) {
    return BlocProvider<PostBloc>(
      creator: (_context, _bag) => PostBloc(postListType: postListType),
      child: PostScreen(postListType),
    );
  }

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends BaseState<PostScreen> {
  PostBloc _postBloc;
  SwiperController _swiperController;

  int changedIndex;
  int lastIndex;
  List<PostModel> listPost;
  PostListType _postListType;

  @override
  void initState() {
    super.initState();
    UserManager.instance.loadUser();
    _postListType = PostListType.featuredPost;
    _postBloc = BlocProvider.of<PostBloc>(context)..initListPost(_postListType, PageInfoDTO());
    _swiperController = SwiperController();
  }

  @override
  void dispose() {
    _swiperController?.dispose();
    _postBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<PostListDTO>(
          stream: _postBloc.listPostStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (changedIndex == snapshot.data.listPost.length - 2) {
                    loadMoreData(notification, snapshot.data);
                  }
                  return false;
                },
                child: Swiper(
                  scrollDirection: Axis.horizontal,
                  physics: snapshot.data.isSwipeable
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    PostModel postModel = snapshot.data.listPost[index];
                    if (changedIndex == snapshot.data.listPost.length - 1) {
                      if (index == 0) {
                        return null;
                      }
                    }
                    if (postModel.error != null) {
                      return Container(
                        child: Center(
                            child: Text(
                          'Nội dung không còn được hiển thị',
                          style: ThemeText.textStyleNormalWhite15,
                        )),
                      );
                    } else {
                      return postContent(postModel, index, snapshot.data);
                    }
                  },
                  itemCount: snapshot.data.listPost.length,
                  curve: Curves.ease,
                  viewportFraction: 1,
                  controller: _swiperController,
                  loop: false,
                  scale: 0.8,
                  onIndexChanged: (index) {
                    changedIndex = index;
//                    print('---------------${changedIndex}');
                    if (index == snapshot.data.listPost.length - 1) lastIndex = snapshot.data.listPost.length - 1;
                  },
                ),
              );
            } else {
              return PendingScreen();
            }
          }),
    );
  }

  Widget postContent(
    data,
    index,
    PostListDTO postListDTO,
  ) {
    return PostItemScreen(
        post: data,
        postListDTO: postListDTO,
        postListType: widget.postListType,
        swiperController: _swiperController,
        index: index,
        size: screenSize,
//        panelController: _pc,
        lastIndex: lastIndex,
        changedIndex: changedIndex);
  }

  Future<void> loadMoreData(ScrollNotification notification, PostListDTO data) async {
    if (notification is ScrollEndNotification) {
      await _postBloc.getMoreDataIntoListPost(_postListType, data);
    }
  }
}
