import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsup/common/const.dart';
import 'package:whatsup/common/constanst/icon_constants.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';
import 'package:whatsup/presentation/theme/theme_text.dart';
import 'package:whatsup/utils/number_utils.dart';

class DislikePostWidget extends StatefulWidget {
  final PostModel post;

  DislikePostWidget(this.post);

  @override
  _DislikePostWidgetState createState() => _DislikePostWidgetState();
}

class _DislikePostWidgetState extends State<DislikePostWidget> {
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _postBloc.dislikeController,
        initialData: widget.post.viewerHasDisliked,
        builder: (context, snapshot) {
          bool data = widget.post.viewerHasDisliked;
          return InkWell(
            onTap: () {
              _postBloc.doDisLike(widget.post);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset(IconConstants.iconDisLikePath,
                    color: data ? Colors.blue : Colors.white,
                    semanticsLabel: 'Dislike'),
                Padding(
                  padding: const EdgeInsets.only(left: number_3),
                  child: Text(
                    NumberUtils.handleNumber(widget.post.dislikeCount),
                    style: ThemeText.textStyleNormalWhite15,
                  ),
                )
              ],
            ),
          );
        });
  }
}
