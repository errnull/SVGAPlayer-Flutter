import 'dart:async';

import 'package:flutter/services.dart';

class Svgaplayer {
  static const MethodChannel _channel =
      const MethodChannel('svgaplayer');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
