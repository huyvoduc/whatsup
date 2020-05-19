import 'package:flutter/material.dart';
import 'package:whatsup/module/profile/__mock__/comment_history_mock_data.dart';
import 'package:whatsup/module/profile/widgets/comment_history_item.dart';

class CommentHistoryTab extends StatefulWidget {
  final double width;

  const CommentHistoryTab({Key key, this.width}) : super(key: key);

  @override
  _CommentHistoryTabState createState() => _CommentHistoryTabState();
}

class _CommentHistoryTabState extends State<CommentHistoryTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: widget.width,
        child: Column(
          children: commentHistory
              .map<CommentHistoryItem>(
                (item) => CommentHistoryItem(
                  item: item,
                  width: widget.width,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
