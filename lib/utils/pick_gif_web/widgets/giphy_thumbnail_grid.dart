import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:whatsup/utils/pick_gif_web/model/giphy_repository.dart';

import 'giphy_context.dart';
import 'giphy_preview_page.dart';
import 'giphy_thumbnail.dart';

/// A selectable grid view of gif thumbnails.
class GiphyThumbnailGrid extends StatelessWidget {
  final GiphyRepository repo;
  final ScrollController scrollController;
  final BuildContext context;

  const GiphyThumbnailGrid(
      {Key key, @required this.repo, this.scrollController, this.context})
      : super(key: key);

  void showDialogLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        controller: scrollController,
        itemCount: repo.totalCount,
        itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
//              showDialogLoading(context);
//              final giphy = GiphyContext.of(context);
              final gif = await repo.get(index);
//              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiphyPreviewPage(
                    url: gif.images.original.url,
                  ),
                ),
              );
            },
            child:
                GiphyThumbnail(key: Key('$index'), repo: repo, index: index)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            childAspectRatio: 1.6,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5));
  }
}
