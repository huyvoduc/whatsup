library giphy_picker;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';

import 'widgets/giphy_context.dart';
import 'widgets/giphy_search_page.dart';

typedef ErrorListener = void Function(dynamic error);

/// Provides Giphy picker functionality.
class GiphyPicker {
  /// Renders a full screen modal dialog for searching, and selecting a Giphy image.
  static void pickGif({
    @required BuildContext context,
    @required String apiKey,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    Widget title,
    ErrorListener onError,
    bool showPreviewPage = true,
    String searchText = 'Search GIPHY',
  }) async {
    GiphyGif result;

    final gif = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GiphyContext(
                  apiKey: apiKey,
                  rating: rating,
                  language: lang,
                  onError:
                      onError ?? (error) => _showErrorDialog(context, error),
                  onSelected: (gif) {
                    result = gif;
                    // pop preview page if necessary
                    if (showPreviewPage) {
                      Navigator.pop(context);
                    }
                    // pop giphy_picker
                    Navigator.pop(context);
                  },
                  showPreviewPage: showPreviewPage,
                  searchText: searchText,
                  child: const GiphySearchPage(),
                ),
            fullscreenDialog: true));
//    Navigator.pop(context);
  }

  static void _showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Giphy error'),
          content:  Text('An error occurred. $error'),
          actions: <Widget>[
             FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
