import 'proto/svga.pb.dart';

class SVGAVideoEntity {
  final MovieEntity entity;
  
  // var antiAlias = true

  //   var videoSize = SVGARect(0.0, 0.0, 0.0, 0.0)
  //       private set

  //   var FPS = 15
  //       private set

  //   var frames: Int = 0
  //       private set

  //   var sprites: List<SVGAVideoSpriteEntity> = listOf()
  //       private set

  //   var audios: List<SVGAAudioEntity> = listOf()

  //   var soundPool: SoundPool? = null

  //   var images = HashMap<String, Bitmap>()
  //       private set

  //   private var cacheDir: File

  const SVGAVideoEntity({
    this.entity,
  })  : assert(entity != null),
        super();

}