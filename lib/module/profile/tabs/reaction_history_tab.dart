import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:whatsup/module/profile/__mock__/post_mock_data.dart';

class ReacionHistoryTab extends StatefulWidget {
  final double width;

  const ReacionHistoryTab({Key key, @required this.width}) : super(key: key);

  @override
  _ReacionHistoryTabState createState() => _ReacionHistoryTabState();
}

class _ReacionHistoryTabState extends State<ReacionHistoryTab> {
  final int crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.zero,
      crossAxisCount: crossAxisCount,
      itemCount: posts.length,
      itemBuilder: (context, idx) {
        return _buildPostItem(posts[idx].imagePath);
      },
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      staggeredTileBuilder: _getStaggeredTile,
    );
  }

  Widget _buildPostItem(
    String imagePath,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  StaggeredTile _getStaggeredTile(int i) {
    final double ratio = posts[i].ratioY * 1.0 / posts[i].ratioX ;
    final height = widget.width / crossAxisCount * ratio;
    return StaggeredTile.extent(1, height);
  }
}
