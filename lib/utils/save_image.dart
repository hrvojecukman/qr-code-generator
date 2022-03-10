import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('$directory/$title.png');
    final savedFile = await imgFile.writeAsBytes(pngBytes);
    _showSavePath(context, savedFile.path);
  }

  _showSavePath(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image saved!'),
          content: Text(filePath),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }
}
