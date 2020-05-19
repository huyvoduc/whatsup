import 'package:flutter/material.dart';
import '../../../utils/life_cycle/base.dart';
// ignore: directives_ordering
import 'package:giphy_client/giphy_client.dart';
import '../../../utils/pick_gif_web/giphy_picker.dart';
import '../../../utils/pick_gif_web/widgets/giphy_image.dart';

class GifWebScreen extends StatefulWidget {
  @override
  _GifWebScreenState createState() => _GifWebScreenState();
}

class _GifWebScreenState extends BaseState<GifWebScreen> {
  GiphyGif _gif;

  final API_KEY = 'JgbxgKWctlyk2DNhQtwwOaW1KceRPKxH';

  @override
  void didPop() {
    debugPrint('_GifWebScreenState.didPop');
    super.didPop();
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  @override
  // ignore: file_names
  Widget build(BuildContext context) {
    debugPrint('_GifWebScreenState.build');
    return Scaffold(
        appBar: AppBar(
          title: Text(_gif?.title ?? 'Giphy Picker Demo'),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
            child: Center(
                child: _gif == null
                    ? const Text('Pick a gif..')
                    : GiphyImage.original(gif: _gif))),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final gif = await GiphyPicker.pickGif(
                context: context, apiKey: API_KEY);
//            if (gif != null) {
//              setState(() => _gif = gif);
//            }
          },
          child: const Icon(Icons.search),
        ));
  }
}
