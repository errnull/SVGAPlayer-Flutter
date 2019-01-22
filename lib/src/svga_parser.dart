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

@immutable
class PictureInfo {
  /// Creates a new PictureInfo object.
  // const PictureInfo({
  //   @required this.picture,
  //   @required this.viewport,
  //   this.size = Size.infinite,
  // })  : assert(picture != null),
  //       assert(viewport != null),
  //       assert(size != null);

  /// The raw picture.
  ///
  /// This is the object to pass to the [Canvas.drawPicture] when painting.
  // final Picture picture;

  // /// The viewport enclosing the coordinates used in the picture.
  // final Rect viewport;

  // /// The requested size for this picture, which may be different than the
  // /// [viewport.size].
  // final Size size;

  // @override
  // int get hashCode => hashValues(picture, viewport, size);

  // @override
  // bool operator ==(Object other) {
  //   if (other.runtimeType != runtimeType) {
  //     return false;
  //   }
  //   final PictureInfo typedOther = other;
  //   return typedOther.picture == picture &&
  //       typedOther.viewport == viewport &&
  //       typedOther.size == size;
  // }
}

abstract class ParseCompletion extends Diagnosticable {
  // final List<PictureListener> _listeners = <PictureListener>[];
  // PictureInfo _current;

  // void addListener(PictureListener listener) {
  //   _listeners.add(listener);
  //   if (_current != null) {
  //     try {
  //       listener(_current, true);
  //     } catch (exception, stack) {
  //       _handleImageError(
  //           'by a synchronously-called image listener', exception, stack);
  //     }
  //   }
  // }

  /// Stop listening for new concrete [ImageInfo] objects.
  // void removeListener(PictureListener listener) {
  //   _listeners.remove(listener);
  // }

  /// Calls all the registered listeners to notify them of a new image.
  @protected
  void setImage(SVGAVideoEntity image) {
    // _current = image;
    // if (_listeners.isEmpty) {
    //   return;
    // }
    // final List<PictureListener> localListeners =
    //     List<PictureListener>.from(_listeners);
    // for (PictureListener listener in localListeners) {
    //   try {
    //     listener(image, false);
    //   } catch (exception, stack) {
    //     _handleImageError('by an image listener', exception, stack);
    //   }
    // }
  }

  // void _handleImageError(String context, dynamic exception, dynamic stack) {
  //   FlutterError.reportError(FlutterErrorDetails(
  //       exception: exception,
  //       stack: stack,
  //       library: 'image resource service',
  //       context: context));
  // }

  /// Accumulates a list of strings describing the object's state. Subclasses
  /// should override this to have their information included in [toString].
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    // description.add(DiagnosticsProperty<PictureInfo>('current', _current,
    //     ifNull: 'unresolved', showName: false));
    // description.add(ObjectFlagProperty<List<PictureListener>>(
    //   'listeners',
    //   _listeners,
    //   ifPresent:
    //       '${_listeners?.length} listener${_listeners?.length == 1 ? "" : "s"}',
    // ));
  }
}

class OneFramePictureStreamCompleter extends ParseCompletion {
  OneFramePictureStreamCompleter(Future<SVGAVideoEntity> entity,
      {InformationCollector informationCollector})
      : assert(entity != null) {
    entity.then<void>(setImage, onError: (dynamic error, StackTrace stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'SVG',
        context: 'resolving a single-frame picture stream',
        informationCollector: informationCollector,
        silent: true,
      ));
    });
  }
}

typedef SVGAEntityDecoder<T> = FutureOr<T> Function(
    T data, String key);

abstract class SVGAParser<T> { 
  const SVGAParser();

    @protected
  ParseCompletion load(T key);

    SVGAVideoEntity resolve() {
    // assert(picture != null);
    // final PictureStream stream = PictureStream()
    T obtainedKey;
    obtainKey().then<void>((T key) {
      obtainedKey = key;
      // stream.setCompleter(_cache.putIfAbsent(key, () => load(key)));
      load(key);
    }).catchError((dynamic exception, StackTrace stack) async {
      FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'services library',
          context: 'while resolving a picture',
          silent: true, // could be a network error or whatnot
          informationCollector: (StringBuffer information) {
            information.writeln('Picture provider: $this');
            if (obtainedKey != null)
              information.writeln('Picture key: $obtainedKey');
          }));
      return null;
    });
    return null;
  }

    @protected
  Future<T> obtainKey();
}

class NetworkSVGAParser extends SVGAParser<NetworkSVGAParser> {

  /// The arguments must not be null.
  const NetworkSVGAParser(this.url, {this.headers})
      : assert(url != null);

  /// The decoder to use to turn a [Uint8List] into a [SVGAEntity] object.
  // final SVGAEntityDecoder<Uint8List> decoder;

    /// The URL from which the picture will be fetched.
  final String url;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch picture from network.
  final Map<String, String> headers;

@override
  Future<NetworkSVGAParser> obtainKey() {
    return SynchronousFuture<NetworkSVGAParser>(this);
  }

  @override
  ParseCompletion load(NetworkSVGAParser key) {
    return OneFramePictureStreamCompleter(_loadAsync(key),
        informationCollector: (StringBuffer information) {
      information.writeln('Picture provider: $this');
      information.write('Picture key: $key');
    });
  }

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