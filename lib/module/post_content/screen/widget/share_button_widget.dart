import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/post_content/bloc/post_bloc.dart';
import '../../../../common/constanst/icon_constants.dart';

class ShareButtonWidget extends StatefulWidget {
  final Color color;
  final VoidCallback onTap;
  final PostModel post;
  final bool isShow;

  ShareButtonWidget(
      {@required this.onTap, this.color, this.post, this.isShow = false});

  @override
  _ShareButtonWidgetState createState() => _ShareButtonWidgetState();
}

class _ShareButtonWidgetState extends State<ShareButtonWidget> {
  PostBloc _postBloc;
  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  void dispose() {
    _postBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
        Share.share('${widget.post.mediaUrl}', subject: 'Chia sẻ với');
        },
        child: SvgPicture.asset(IconConstants.iconShareRight,
            color: widget.color, semanticsLabel: 'Share'),
      ),
    );
  }
}
