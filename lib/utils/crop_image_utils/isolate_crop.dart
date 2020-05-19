//import 'dart:typed_data';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:extended_image_library/extended_image_library.dart';
import 'package:flutter/foundation.dart';
import 'package:http_client_helper/http_client_helper.dart';
import "package:isolate/load_balancer.dart";
import "package:isolate/isolate_runner.dart";
import 'dart:ui' hide Image;
import 'package:image/image.dart';
import 'package:image_editor/image_editor.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'extented_image_editor.dart';

final loadBalancer = LoadBalancer.create(1, IsolateRunner.spawn);

Future<dynamic> isolateDecodeImage(List<int> data) async {
  final response = ReceivePort();
  await Isolate.spawn(_isolateDecodeImage, response.sendPort);
  final sendPort = await response.first;
  final answer = ReceivePort();
  sendPort.send([answer.sendPort, data]);
  return answer.first;
}

void _isolateDecodeImage(SendPort port) {
  final rPort = ReceivePort();
  port.send(rPort.sendPort);
  rPort.listen((message) {
    final send = message[0] as SendPort;
    final data = message[1] as List<int>;
    send.send(decodeImage(data));
  });
}

Future<dynamic> isolateEncodeImage(Image src) async {
  final response = ReceivePort();
  await Isolate.spawn(_isolateEncodeImage, response.sendPort);
  final sendPort = await response.first;
  final answer = ReceivePort();
  sendPort.send([answer.sendPort, src]);
  return answer.first;
}

void _isolateEncodeImage(SendPort port) {
  final rPort = ReceivePort();
  port.send(rPort.sendPort);
  rPort.listen((message) {
    final send = message[0] as SendPort;
    final src = message[1] as Image;
    send.send(encodeJpg(src));
  });
}

Future<File> cropImageDataWithDartLibrary(
    {ExtendedImageEditorState state}) async {

  ///crop rect base on raw image
  final Rect cropRect = state.getCropRect();

  // in web, we can't get rawImageData due to .
  // using following code to get imageCodec without download it.
  // final Uri resolved = Uri.base.resolve(key.url);
  // // This API only exists in the web engine implementation and is not
  // // contained in the analyzer summary for Flutter.
  // return ui.webOnlyInstantiateImageCodecFromUrl(
  //     resolved); //
  final data = kIsWeb &&
      state.widget.extendedImageState.imageWidget.image
      is ExtendedNetworkImageProvider
      ? await _loadNetwork(state.widget.extendedImageState.imageWidget.image)
  ///toByteData is not work on web
  ///https://github.com/flutter/flutter/issues/44908
  // (await state.image.toByteData(format: ui.ImageByteFormat.png))
  //     .buffer
  //     .asUint8List()
      : state.rawImageData;

  final EditActionDetails editAction = state.editAction;

  var time1 = DateTime.now();

  /// it costs much time and blocks ui.
  //Image src = decodeImage(data);

  /// it will not block ui with using isolate.
  //Image src = await compute(decodeImage, data);
  //Image src = await isolateDecodeImage(data);
  Image src;
  LoadBalancer lb;
  if (kIsWeb) {
    src = decodeImage(data);
  } else {
    lb = await loadBalancer;
    src = await lb.run<Image, List<int>>(decodeImage, data);
  }

  var time2 = DateTime.now();

  debugPrint("${time2.difference(time1)} : decode");

  //clear orientation
  src = bakeOrientation(src);

  if (editAction.needCrop)
    src = copyCrop(src, cropRect.left.toInt(), cropRect.top.toInt(),
        cropRect.width.toInt(), cropRect.height.toInt());

  if (editAction.needFlip) {
    Flip mode;
    if (editAction.flipY && editAction.flipX) {
      mode = Flip.both;
    } else if (editAction.flipY) {
      mode = Flip.horizontal;
    } else if (editAction.flipX) {
      mode = Flip.vertical;
    }
    src = flip(src, mode);
  }

  if (editAction.hasRotateAngle) src = copyRotate(src, editAction.rotateAngle);

  var time3 = DateTime.now();
  debugPrint("${time3.difference(time2)} : crop/flip/rotate");

  /// you can encode your image
  ///
  /// it costs much time and blocks ui.
  //var fileData = encodeJpg(src);

  /// it will not block ui with using isolate.
  //var fileData = await compute(encodeJpg, src);
  //var fileData = await isolateEncodeImage(src);
  List<int> fileData;
  if (kIsWeb) {
    fileData = encodeJpg(src);
  } else {
    fileData = await lb.run<List<int>, Image>(encodeJpg, src);
  }

  var time4 = DateTime.now();
  debugPrint("${time4.difference(time3)} : encode");
  debugPrint("${time4.difference(time1)} : total time");

  File _fileImage;
  int random;
  random = Random().nextInt(10000);
  _fileImage = File('${(await getTemporaryDirectory()).path}/$random.jpg');
  await _fileImage.writeAsBytes(fileData);
  debugPrint('msg: ${"save image : ${_fileImage.path}"}');
  return _fileImage;
}


/// it may be failed, due to Cross-domain
Future<Uint8List> _loadNetwork(ExtendedNetworkImageProvider key) async {
  try {
    Response response = await HttpClientHelper.get(key.url,
        headers: key.headers,
        timeLimit: key.timeLimit,
        timeRetry: key.timeRetry,
        retries: key.retries,
        cancelToken: key.cancelToken);
    return response.bodyBytes;
  } on OperationCanceledError catch (_) {
    debugPrint('User cancel request ${key.url}.');
    return Future.error(StateError('User cancel request ${key.url}.'));
  } catch (e) {
    return Future.error(StateError('failed load ${key.url}. \n $e'));
  }
}
