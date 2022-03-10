import 'dart:core';
// import 'dart:io' if (dart.library.html) 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:path_provider/path_provider.dart';

mixin SaveImage {
  Future<void> saveImage({
    required GlobalKey globalKey,
    required String title,
    required BuildContext context,
  }) async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    XFile file = new XFile.fromData(pngBytes);
    _savePlatformSpecific(file: file, context: context, title: title);
  }

  _savePlatformSpecific({
    required XFile file,
    required String title,
    required BuildContext context,
  }) async {
    final WebImageDownloader _webImageDownloader = WebImageDownloader();

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      _webImageDownloader.downloadImageFromUInt8List(
        uInt8List: bytes,
        imageQuality: 0.5,
      );
    } else {
      final directory = (await getApplicationDocumentsDirectory()).path;
      final path = '$directory/$title.png';
      await file.saveTo(path);
      _showSavePath(context, path);
    }
  }

  _showSavePath(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image saved!'),
          content: GestureDetector(
            onTap: () => _copyTex(filePath, context),
            child: Text(filePath),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: Navigator.of(context).pop,
                ),
                ElevatedButton(
                  child: const Text('Copy path'),
                  onPressed: () => _copyTex(filePath, context),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _copyTex(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Path copied to clipboard!")));
    });
  }
}
