import 'package:bloc_provider/bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/dto/page_info_dto.dart';
import 'package:whatsup/model/comment_model.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/module/comments/bloc/comment_bloc.dart';
import 'package:whatsup/presentation/theme/theme_text.dart';
import 'package:whatsup/utils/life_cycle/base.dart';

class FooterReplyWidget extends StatefulWidget {
  final int currentIdx;
  final List<CommentModel> listComment;
  final PostModel postModel;
  final PageInfoDTO pageInfoDTO;
  final CommentModel commentModel;

  FooterReplyWidget(this.commentModel, this.currentIdx, this.listComment, this.postModel, this.pageInfoDTO,);

  @override
  _FooterReplyWidgetState createState() => _FooterReplyWidgetState();
}

class _FooterReplyWidgetState extends BaseState<FooterReplyWidget> {
  CommentBloc _commentBloc;

  @override
  void initState() {
    super.initState();
    _commentBloc = BlocProvider.of<CommentBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF242a37),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.commentModel.remainingReply > 0 ? Row(
            children: <Widget>[
              Spacer(
                flex: 1,
              ),
              SizedBox(
                width: 28,
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: (){
                      _commentBloc.getRemainingReply(widget.listComment,
                          widget.currentIdx, widget.commentModel, widget.postModel, widget.pageInfoDTO);
                    },
                    child: Text(
                      'Xem thêm ${widget.commentModel.remainingReply} kết quả khác',
                      style: ThemeText.textStyleNormalWhite17,
                    ),
                  ),
                ),
              ),
            ],
          ) : Container(),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Container(
                  width: 20,
                  height: 20,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      widget.commentModel.createdBy.avatarPhotoUrl,
                      errorListener: _errorImgListenr
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.only(left: 12, right: 18),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      autofocus: false,
                      controller: TextEditingController(),
                      style: ThemeText.textStyleNormalWhite15,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        hintText: 'Viết trả lời ...',
                        hintStyle: ThemeText.textStyleNormalWhite15,
                        filled: true,
                        fillColor: Color(0xFF485164),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 7.0, top: 7.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _errorImgListenr() {
    print('abc');
  }
}
