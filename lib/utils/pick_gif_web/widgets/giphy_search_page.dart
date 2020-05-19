import 'package:flutter/material.dart';
import 'giphy_search_view.dart';

class GiphySearchPage extends StatelessWidget {
  final Widget title;

  const GiphySearchPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.black,
        body: SafeArea( bottom: false,child: GiphySearchView()));
  }
}
