import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:whatsup/common/widgets/circle_image.dart';
import 'package:whatsup/common/widgets/simple_icon_button.dart';
import 'package:whatsup/module/profile/tabs/activities_history_tab.dart';
import 'package:whatsup/module/profile/tabs/activities_tab.dart';
import 'package:whatsup/module/profile/tabs/comment_history_tab.dart';
import 'package:whatsup/module/profile/tabs/notification_tab.dart';
import 'package:whatsup/module/profile/tabs/observer_tab.dart';
import 'package:whatsup/module/profile/tabs/reaction_history_tab.dart';
import '../../common/constanst/route_constants.dart';
import '../../presentation/theme/theme_color.dart';
import '../../utils/dimension.dart';
import '__mock__/profile_mock_data.dart';
import 'edit_profile/edit_personal_information_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final double avatarAppbarPadding = 50;
  final double initialAvatarPadding = 10;
  final double tabControlHeight = 60;
  final double appbarHeight = max(Dimension.getHeight(0.5), 215);
  final double socialPropertiesContainerHeight = 100;
  final double nameAndAvatarHeight = 170;
  double get avatarSize => nameAndAvatarHeight / 3.4;
  double get bgHeight => appbarHeight - tabControlHeight;
  final int tabCount = 6;

  final ScrollController _scrollController = ScrollController();
  final StreamController<double> _streamController =
      StreamController.broadcast();

  TabController _tabController;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset < bgHeight) {
        //update avatar padding
        final padding =
            _scrollController.offset / bgHeight * avatarAppbarPadding;
        _streamController.add(padding + initialAvatarPadding);
      }
    });
    _tabController = TabController(length: tabCount, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildAppbar(),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    color: AppColor.primaryColor,
                    height: tabControlHeight,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.dashboard,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.notifications,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.remove_red_eye,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.favorite,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.access_time,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.chat,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ];
        },
        body: Container(
          color: AppColor.primaryColor,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ActivitiesTab(
                width: Dimension.width,
              ),
              NotificationTab(
                width: Dimension.width,
              ),
              ObserverTab(
                width: Dimension.width,
              ),
              ReacionHistoryTab(
                width: Dimension.width,
              ),
              ActivitiesHistoryTab(
                width: Dimension.width,
              ),
              CommentHistoryTab(
                width: Dimension.width,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return SliverAppBar(
      expandedHeight: appbarHeight,
      floating: false,
      pinned: true,
      snap: false,
      actionsIconTheme: const IconThemeData(opacity: 1.0),
      leading: SimpleIconButton(
        height: 40,
        width: 40,
        icon: Icon(Icons.menu),
        borderColor: Colors.transparent,
        borderRadius: 0,
        onPressed: _handleClickMenu,
      ),
      actions: <Widget>[
        SimpleIconButton(
          height: 40,
          width: 40,
          icon: const Icon(Icons.share),
          borderColor: Colors.transparent,
          borderRadius: 0,
          onPressed: _handleClickShare,
        ),
        SimpleIconButton(
          height: 40,
          width: 40,
          icon: const Icon(Icons.more_vert),
          borderColor: Colors.transparent,
          borderRadius: 0,
          onPressed: _showModalPopup,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        collapseMode: CollapseMode.pin,
        centerTitle: false,
        title: _buildNameAndAvatar(),
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          children: <Widget>[
            SizedBox(
              height: appbarHeight,
              child: Image.asset(
                ProfileMockData.cover,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: socialPropertiesContainerHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: const [
                      Colors.transparent,
                      AppColor.primaryColor,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _buildSocialItemProperties(
                      'Bài viết',
                      '128',
                    ),
                    _buildSocialItemProperties(
                      'Đang đăng ký',
                      '3120',
                    ),
                    _buildSocialItemProperties(
                      'Người đăng ký',
                      '5024',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndAvatar() {
    return Container(
      width: Dimension.width,
      padding: EdgeInsets.only(top: Dimension.statusBarHeight),
      height: nameAndAvatarHeight,
      child: Align(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<double>(
              initialData: initialAvatarPadding,
              stream: _streamController.stream,
              builder: (context, snapshot) {
                return Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: snapshot.data, top: 5, bottom: 5),
                      child: CircleImage(
                        image: Image.asset(
                          ProfileMockData.imageAvatar,
                          fit: BoxFit.cover,
                          height: avatarSize,
                          width: avatarSize,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Blanche Hall',
                          style: Theme.of(context).textTheme.title.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                        ),
                        Text(
                          '@jorgecutis',
                          style: Theme.of(context).textTheme.title.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w200,
                              ),
                        ),
                      ],
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSocialItemProperties(
    String title,
    String value,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: Theme.of(context).textTheme.title.copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.title.copyWith(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w200,
              ),
        )
      ],
    );
  }

  //function
  void _handleClickShare() {
    Share.share('This is share content!');
  }

  void _handleClickMenu() {
    Navigator.pop(context);
  }

  Future<void> _showModalPopup() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditPersonalInfomationScreen();
                }));
              },
              child: const Text(
                'Chỉnh sửa trang cá nhân',
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteList.setting);
              },
              child: const Text('Cài đặt'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {},
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }
}
