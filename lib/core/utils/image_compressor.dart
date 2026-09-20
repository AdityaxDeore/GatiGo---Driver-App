import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// On-device high performance document and image compressor for GatiGo Driver app.
class ImageCompressor {
  ImageCompressor._();

  /// Compresses raw image bytes to a target bounding box using Flutter's engine.
  static Future<Uint8List> compressBytes(
    Uint8List inputBytes, {
    int targetWidth = 1280,
    int targetHeight = 1280,
  }) async {
    final codec = await ui.instantiateImageCodec(
      inputBytes,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );
    final frameInfo = await codec.getNextFrame();
    final byteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List() ?? inputBytes;
  }

  /// Compresses a local document or photo file into optimized bytes on-device.
  static Future<Uint8List> compressFile(
    File file, {
    int targetWidth = 1280,
    int targetHeight = 1280,
  }) async {
    final rawBytes = await file.readAsBytes();
    if (rawBytes.lengthInBytes <= 150 * 1024) {
      return rawBytes;
    }
    return compressBytes(rawBytes, targetWidth: targetWidth, targetHeight: targetHeight);
  }
}
