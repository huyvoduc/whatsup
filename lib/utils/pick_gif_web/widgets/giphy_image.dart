import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image;
import 'giphy_overlay.dart';

/// Loads and renders a Giphy image.
class GiphyImage extends StatefulWidget {
  final String url;
  final Widget placeholder;
  final double width;
  final double height;
  final BoxFit fit;
  final bool renderGiphyOverlay;

  /// Loads an image from given url.
  const GiphyImage(
      {Key key,
      @required this.url,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true})
      : super(key: key);

  /// Loads the original image for given Giphy gif.
  GiphyImage.original(
      {Key key,
      @required GiphyGif gif,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true})
      : url = gif.images.original.url,
        super(key: key ?? Key(gif.id));

  /// Loads the original still image for given Giphy gif.
  GiphyImage.originalStill(
      {Key key,
      @required GiphyGif gif,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true})
      : url = gif.images.originalStill.url,
        super(key: key ?? Key(gif.id));

  @override
  _GiphyImageState createState() => _GiphyImageState();

  /// Loads the images bytes for given url from Giphy.
  static Future<List<int>> load(String url, {Client client}) async {
    // ignore: prefer_asserts_with_message
    assert(url != null);

    final response =
        await (client ?? Client()).get(url, headers: {'accept': 'image/*'});

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    return null;
  }
}

class _GiphyImageState extends State<GiphyImage> {
  Future<List<int>> _loadImage;
  File _fileImage;
  int random;
  bool done = false;

  @override
  void initState() {
    debugPrint('_GiphyImageState.initState');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return done
        ? Image.file(_fileImage)
        : const Center(child: const CircularProgressIndicator());
  }

}
