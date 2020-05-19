import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/model/comment_model.dart';

class ImageCommentViewWidget extends ModalRoute<void> {
  final String url;
  Size size;
  final CommentModel commentModel;

  ImageCommentViewWidget({this.url, this.size, this.commentModel});

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      color: Color(0xFF242a37),
      child: SizedBox(
          height: size.height,
          width: size.width,
          child: commentModel.dimensions.height < size.height
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        child: Image(
                          image: CachedNetworkImageProvider(
                            commentModel.media.mediaUrl,
                          ),
                          height: commentModel.dimensions.height,
                          width: commentModel.dimensions.width,
                        ),
                      ),

                    ),
                  ],
                )
              : Center(
                child: Stack(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
//                        top: 30.0,
                        margin: EdgeInsets.only(left: 10, top: 30),
//                    alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 35,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: ScrollController(),
                            shrinkWrap: true,
                            children: [
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                    commentModel.media.mediaUrl,
                                  ),
                                  height: commentModel.dimensions.height,
                                  width: commentModel.dimensions.width,
                                ),

                              ),
                            ]),
                      ),
                    ],
                  ),
              )

//        Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(top: 30.0, left: 10),
//              child: IconButton(
//                  icon: Icon(
//                    Icons.close,
//                    color: Colors.white,
//                    size: 30,
//                  ),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  }),
//            ),
//            Expanded(
//              child: CachedNetworkImage(
//                imageUrl: url,
//                placeholder: (context, url) => PendingScreen(),
//                errorWidget: (context, url, error) => Icon(Icons.error),
//                fit: BoxFit.fitWidth,
//              ),
//            ),
//          ],
//        ),
          ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
