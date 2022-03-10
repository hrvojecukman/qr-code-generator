import 'dart:async';
// import 'dart:io' if (dart.library.html) 'dart:html';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QR extends StatelessWidget {
  final String message;
  final Color color;
  final XFile? file;

  const QR({
    required this.message,
    required this.color,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image?>(
      future: _loadOverlayImage(file),
      builder: (ctx, snapshot) {
        final size = MediaQuery.of(context).size.width / 2;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final image = snapshot.data;
        return Container(
          color: Colors.white,
          child: CustomPaint(
            size: Size.square(size),
            painter: QrPainter(
              data: message,
              version: QrVersions.auto,
              eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: color),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: color,
              ),
              //Quality
              errorCorrectionLevel: 3,
              embeddedImage: image,
              embeddedImageStyle: QrEmbeddedImageStyle(),
            ),
          ),
        );
      },
    );
  }

  Future<ui.Image?> _loadOverlayImage(XFile? file) async {
    if (file == null) return Future.value(null);
    final completer = Completer<ui.Image>();
    final bytes = await file.readAsBytes();
    print(bytes.length);
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }
}
