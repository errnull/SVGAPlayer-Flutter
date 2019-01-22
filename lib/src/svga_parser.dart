import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:archive/archive.dart';

import 'proto/svga.pb.dart';
import 'proto/svga.pbenum.dart';
import 'proto/svga.pbjson.dart';
import 'proto/svga.pbserver.dart';

import 'svga_video_entity.dart';

typedef SVGAEntityDecoder<T> = FutureOr<T> Function(
    T data, String key);

abstract class SVGAParser<T> { 
  const SVGAParser();
}

class NetworkSVGAParser extends SVGAParser<NetworkSVGAParser> {

  /// The arguments must not be null.
  const NetworkSVGAParser(this.decoder, this.url, {this.headers})
      : assert(url != null);

  /// The decoder to use to turn a [Uint8List] into a [SVGAEntity] object.
  final SVGAEntityDecoder<Uint8List> decoder;

    /// The URL from which the picture will be fetched.
  final String url;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch picture from network.
  final Map<String, String> headers;

@override
  Future<NetworkSVGAParser> obtainKey() {
    return SynchronousFuture<NetworkSVGAParser>(this);
  }

  // @override
  // PictureStreamCompleter load(NetworkSVGAParser key) {
  //   return OneFramePictureStreamCompleter(_loadAsync(key),
  //       informationCollector: (StringBuffer information) {
  //     information.writeln('Picture provider: $this');
  //     information.write('Picture key: $key');
  //   });
  // }

  Future<SVGAVideoEntity> _loadAsync(NetworkSVGAParser key) async {
    assert(key == this);

    var manager = DefaultCacheManager();
    var file = await manager.getSingleFile(url);
    final Uint8List bytes = await file.readAsBytes();
    var inflate = new ZLibDecoder().decodeBytes(bytes);
    var entity = MovieEntity.fromBuffer(inflate);
    return SVGAVideoEntity(entity: entity);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final NetworkSVGAParser typedOther = other;
    return url == typedOther.url;
  }

  // @override
  // int get hashCode => hashValues(ur);

  // @override
  // String toString() =>
      // '$runtimeType("$url", headers: $headers, colorFilter: $colorFilter)';
// }
}