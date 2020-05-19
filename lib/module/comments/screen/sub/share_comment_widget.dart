import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/comments/bloc/comment_bloc.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';
import '../../../../common/constanst/icon_constants.dart';

class ShareCommentWidget extends StatefulWidget {
  final Color color;
  final VoidCallback onTap;
  final PostModel post;
  final bool isShow;

  ShareCommentWidget(
      {@required this.onTap, this.color, this.post, this.isShow = false});

  @override
  _ShareCommentWidgetState createState() => _ShareCommentWidgetState();
}

class _ShareCommentWidgetState extends State<ShareCommentWidget> {
  CommentBloc _commentBloc;
  @override
  void initState() {
    super.initState();
    _commentBloc = BlocProvider.of<CommentBloc>(context);
  }

  @override
  void dispose() {
    _commentBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
//          _commentBloc.showShareDialog(widget.post);
        },
        child: SvgPicture.asset(IconConstants.iconShareRight,
            width: 19.42,
            height: 18.79,
            color: widget.color, semanticsLabel: 'Share'),
      ),
    );
  }
}
