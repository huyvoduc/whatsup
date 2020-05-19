import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:whatsup/common/const.dart';
import 'package:whatsup/common/constanst/icon_constants.dart';
import 'package:whatsup/model/post_model.dart';
import 'package:whatsup/presentation/theme/theme_text.dart';

class SharePostItemWidget extends StatelessWidget {
  final PostModel post;
  Size size;
  List<Widget> listTopShare = [];
  List<Widget> listBottomShare = [];

  SharePostItemWidget(this.post, {this.size}){
    listTopShare = topShareList();
    listBottomShare = bottomShareList();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: number_10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: ((size.height / 3 - 50) / 2) * 0.9,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return listTopShare[index];
              },
              itemCount: listTopShare.length,
            ),
          ),
          SizedBox(
            width: size.width * 0.9,
            height: 1,
            child: Container(
              color: Colors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: number_10),
            height: ((size.height / 3 - 50) / 2) * 0.9,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return listBottomShare[index];
                },
                itemCount: listBottomShare.length),
          ),
        ],
      ),
    );
  }

  List<Widget> bottomShareList (){
    return [
      SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.not_interested),
            AutoSizeText(
              'Không \nquan tâm',
              textAlign: TextAlign.center,
              style: ThemeText.textStyleBlack13,
              maxLines: 2,
            )
          ],
        ),
      ),
      SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.report_problem),
            Text(
              'Báo cáo',
              textAlign: TextAlign.center,
              style: ThemeText.textStyleBlack13,
            )
          ],
        ),
      ),
      SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.save_alt),
            Text(
              'Lưu video',
              textAlign: TextAlign.center,
              style: ThemeText.textStyleBlack13,
            )
          ],
        ),
      ),
      SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.favorite_border),
            AutoSizeText(
              'Thêm vào yêu thích',
              textAlign: TextAlign.center,
              style: ThemeText.textStyleBlack13,
              maxLines: 3,
            )
          ],
        ),
      ),
    ];
  }

  List<Widget> topShareList() {
    return [
      SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                IconConstants.iconMessenger,
                semanticsLabel: 'Messenger',
                height: 40,
                width: 40,
              ),
            ),
            Text(
              'Messenger',
              textAlign: TextAlign.center,
              style: ThemeText.textStyleBlack13,
            )
          ],
        ),
      ),
      SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: Image.asset(
                IconConstants.iconFB,
                height: 40,
                width: 40,
              ),
            ),
            Text(
              'Facebook',
              textAlign: TextAlign.center,
              style: ThemeText.textStyleBlack13,
            )
          ],
        ),
      ),
      SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.message,
              color: Colors.blue,
              size: 35,
            ),
            AutoSizeText(
              'Tin nhắn',
              textAlign: TextAlign.center,
              style: ThemeText.textStyleBlack13,
              maxLines: 2,
            )
          ],
        ),
      ),
      SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(
              IconConstants.iconTwistter,
              semanticsLabel: 'Twistter',
              height: 40,
              width: 40,
            ),
            Text(
              'Twistter',
              textAlign: TextAlign.center,
              style: ThemeText.textStyleBlack13,
            )
          ],
        ),
      ),
      InkWell(
        onTap: () {
          Share.share(post.mediaUrl);
        },
        child: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.more_horiz,
                size: 35,
              ),
              Text(
                'Khác',
                textAlign: TextAlign.center,
                style: ThemeText.textStyleBlack13,
              )
            ],
          ),
        ),
      ),
    ];
  }

}