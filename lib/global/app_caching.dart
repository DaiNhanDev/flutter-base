import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';

import '../constants/app_images.dart';

class AppCaching {
  static final AppCaching _singleton = AppCaching._internal();

  factory AppCaching() {
    return _singleton;
  }

  AppCaching._internal();

  final Map<String, Uint8List> _cache = {};
  double devicePixelRatio = 1.0;

  Future<Uint8List> loadImage(String url) {
    final completer = Completer<Uint8List>();
    final imageStream = AssetImage(url)
        .resolve(ImageConfiguration(devicePixelRatio: devicePixelRatio));
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        imageInfo.image
            .toByteData(format: ImageByteFormat.png)
            .then((ByteData? byteData) {
          imageStream.removeListener(listener);
          completer.complete(byteData?.buffer.asUint8List());
        });
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        imageStream.removeListener(listener);
        completer.completeError(exception);
      },
    );

    imageStream.addListener(listener);

    return completer.future;
  }

  Future<void> preloadBeforeAppStart() async {
    final paths = [
      AppImagesAsset.logoSologan,
      AppImagesAsset.copyright,
    ];
    await Future.wait(paths.map((path) async {
      final data = await loadImage(path);
      _cache[path] = data;
    }));
  }

  Uint8List? cacheImageData(String path) => _cache[path];
}
