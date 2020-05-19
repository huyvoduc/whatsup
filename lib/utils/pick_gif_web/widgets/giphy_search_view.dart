import 'dart:async';

import 'package:flutter/material.dart';
import '../model/giphy_repository.dart';

import 'giphy_context.dart';
import 'giphy_thumbnail_grid.dart';

/// Provides the UI for searching Giphy gif images.
class GiphySearchView extends StatefulWidget {
  @override
  _GiphySearchViewState createState() => _GiphySearchViewState();
}

class _GiphySearchViewState extends State<GiphySearchView> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _repoController = StreamController<GiphyRepository>();

  @override
  void initState() {
    // initiate search on next frame (we need context)
    Future.delayed(Duration.zero, () {
      final giphy = GiphyContext.of(context);
      _search(giphy);
    });
    super.initState();
  }

  @override
  void dispose() {
    _repoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final giphy = GiphyContext.of(context);

    return Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
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
                            decoration: InputDecoration(
                                hintText: giphy.searchText,
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                border: InputBorder.none,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _textController.text = "";
                                    setState(() {});
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.grey[500],
                                  ),
                                )),
                            onChanged: (value) => _delayedSearch(giphy, value),
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
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          )),
      Expanded(
          child: StreamBuilder(
              stream: _repoController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.totalCount > 0
                      ? NotificationListener(
                          onNotification: (n) {
                            // hide keyboard when scrolling
                            if (n is UserScrollNotification) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              return true;
                            }
                            return false;
                          },
                          child: RefreshIndicator(
                              onRefresh: () =>
                                  _search(giphy, term: _textController.text),
                              child: GiphyThumbnailGrid(
                                context:context,
                                  key: Key('${snapshot.data.hashCode}'),
                                  repo: snapshot.data,
                                  scrollController: _scrollController)),
                        )
                      : const Center(child: Text('No results'));
                } else if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred'));
                }
                return const Center(child: CircularProgressIndicator());
              }))
    ]);
  }

  void _delayedSearch(GiphyContext giphy, String term) => Future.delayed(
      const Duration(milliseconds: 500), () => _search(giphy, term: term));

  Future _search(GiphyContext giphy, {String term = ''}) async {
    // skip search if term does not match current search text
    if (term != _textController.text) {
      return;
    }

    try {
      // search, or trending when term is empty
      final repo = await (term.isEmpty
          ? GiphyRepository.trending(
              apiKey: giphy.apiKey,
              rating: giphy.rating,
              onError: giphy.onError)
          : GiphyRepository.search(
              apiKey: giphy.apiKey,
              query: term,
              rating: giphy.rating,
              lang: giphy.language,
              onError: giphy.onError));

      // scroll up
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _repoController.add(repo);
    } catch (error) {
      _repoController.addError(error);
      giphy.onError(error);
    }
  }
}
