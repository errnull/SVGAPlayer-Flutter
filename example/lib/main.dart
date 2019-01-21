import 'package:flutter/material.dart';
import 'package:svgaplayer/flutter_svga.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SVGAPlayer Flutter'),
        ),
        body: Center(
          child: SVGAPlayer(
            url: "https://github.com/yyued/SVGA-Samples/blob/master/kingset.svga?raw=true",
          ),
        ),
      ),
    );
  }
}
