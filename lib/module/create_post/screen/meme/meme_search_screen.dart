import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/api/api.dart';
import 'package:whatsup/module/create_post/screen/image/crop_image_screen.dart';
import 'package:whatsup/module/create_post/screen/meme/meme_web_model.dart';
import 'package:whatsup/utils/life_cycle/base.dart';
import 'package:whatsup/utils/pick_gif_web/widgets/giphy_preview_page.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

import 'meme_search_bloc.dart';

class MemeSearchScreen extends StatefulWidget {
  static Widget newInstance() {
    return BlocProvider<MemeSearchBloc>(
      creator: (_context, _bag) => MemeSearchBloc(),
      child: MemeSearchScreen(),
    );
  }

  @override
  _MemeSearchScreenState createState() => _MemeSearchScreenState();
}

class _MemeSearchScreenState extends BaseState<MemeSearchScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  MemeSearchBloc _bloc;
  int _tabActive = 0;

  @override
  void initState() {
    _bloc = BlocProvider.of<MemeSearchBloc>(context);
    super.initState();
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (_tabActive != 0) {
              _bloc.getListMeme(type: 'new');
              _tabActive = 0;
              setState(() {});
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: _tabActive == 0
                    ? Color.fromRGBO(52, 52, 57, 1.0)
                    : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: WText('new'),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_tabActive != 1) {
              _bloc.getListMeme(type: 'popular');

              _tabActive = 1;
              setState(() {});
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: _tabActive == 1
                    ? Color.fromRGBO(52, 52, 57, 1.0)
                    : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: WText('popular'),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_tabActive != 2) {
              _bloc.getListMeme(type: 'other');
              _tabActive = 2;
              setState(() {});
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: _tabActive == 2
                    ? Color.fromRGBO(52, 52, 57, 1.0)
                    : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: WText('other'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 8),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: Color.fromRGBO(53, 53, 57, 1)),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.search,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _textController,
                                  onChanged: (data){
                                    if(data == ''){
                                      if (_tabActive == 0) {
                                        _bloc.getListMeme(type: 'new');
                                      }
                                      if (_tabActive == 1) {
                                        _bloc.getListMeme(type: 'popular');
                                      }
                                      if (_tabActive == 2) {
                                        _bloc.getListMeme(type: 'other');
                                      }
                                    }
                                  },
                                  onSubmitted: (data){
                                    _bloc.searchMeme(text: data);
                                  },
                                  decoration: InputDecoration(
                                      hintText: "",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      border: InputBorder.none,
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _textController.text = "";
                                          setState(() {});
                                          if (_tabActive == 0) {
                                            _bloc.getListMeme(type: 'new');
                                          }
                                          if (_tabActive == 1) {
                                            _bloc.getListMeme(type: 'popular');
                                          }
                                          if (_tabActive == 2) {
                                            _bloc.getListMeme(type: 'other');
                                          }
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.grey[500],
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )),
            const SizedBox(
              height: 8,
            ),
            _buildTabBar(),
            Expanded(
                child: StreamBuilder<MemeWebModel>(
                    stream: _bloc.streamMeme,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return _buildListMeme(snapshot.data.data);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }))
          ]),
        ),
      ),
    );
  }

  Widget _buildListMeme(List<Datum> data) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        itemBuilder: (_, index) {
          if (index % 3 == 1 || index % 3 == 2) {
            return const SizedBox();
          }
          return _buildItemMeme(
              data[index],
              index + 1 >= data.length ? null : data[index + 1],
              index + 2 >= data.length ? null : data[index + 2]);
        },
        itemCount: data.length,
      ),
    );
  }

  Widget _buildItemMeme(Datum m1, Datum m2, Datum m3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            pushScreenOther(CropImageScreen(
              url: m1.mediaUrl,
              isMeme: true,
            ));
          },
          child: Image.network(
            m1.thumbnail,
            width: 100,
          ),
        ),
        m2 == null
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  pushScreenOther(CropImageScreen(
                    url: m2.mediaUrl,
                    isMeme: true,
                  ));
                },
                child: Image.network(
                  m2.thumbnail,
                  width: 100,
                ),
              ),
        m3 == null
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  pushScreenOther(CropImageScreen(
                    url: m3.mediaUrl,
                    isMeme: true,
                  ));
                },
                child: Image.network(
                  m3.thumbnail,
                  width: 100,
                ),
              ),
      ],
    );
  }
}
