// import 'dart:async';

// import 'package:flutter/services.dart';

// class Svgaplayer {
//   static const MethodChannel _channel =
//       const MethodChannel('svgaplayer');

//   static Future<String> get platformVersion async {
//     final String version = await _channel.invokeMethod('getPlatformVersion');
//     return version;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class SVGAPlayer extends StatefulWidget {

    const SVGAPlayer({
    Key key,
    this.url,
    this.httpHeaders
  })  : assert(url != null),
        super(key: key);

  /// The target svga network resource that is displayed.
  final String url;

  /// Optional headers for the http request of the svga recource url
  final Map<String, String> httpHeaders;

 @override
  State<StatefulWidget> createState() => new _SVGAPlayerState();
}

class _SVGAPlayerState extends State<SVGAPlayer> {

  String showMessage = "Hello SVGA";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Text(showMessage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  
  }

  @override
  void didUpdateWidget(SVGAPlayer oldWidget) {
      super.didUpdateWidget(oldWidget);
    }

  @override
  void reassemble() {
      super.reassemble();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
  }

  void _updatePhase() {
    // TODO: Succcessed.
    // TODO: Parser SVGA file.
    setState(() {
      showMessage = "Load success";
    });
  }

  void _fileLoadingFailed() {
      // TODO: Failed.
      setState(() {
      showMessage = "Load failed";
    });
  }
}