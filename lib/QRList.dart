import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_generator/QR.dart';

import 'app/RollaLinks.dart';

class QRList extends StatelessWidget {
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          for (int j = 0; j < RollaLinks.rollaLinks.entries.length; j++) {
            _capturePng(
              j,
              "R" + RollaLinks.rollaLinks.keys.toList()[j].toString(),
            );
          }
        },
        child: const Text('Save'),
      ),
      body: GridView.count(
        primary: false,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 1,
        children: [
          for (int i = 0; i < RollaLinks.rollaLinks.entries.length; i++)
            Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "R " +
                            RollaLinks.rollaLinks.keys.toList()[i].toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        RollaLinks.rollaLinks.values.toList()[i],
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: QR(
                      message: RollaLinks.rollaLinks.values.toList()[i],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _capturePng(int index, String rollaId) async {
    RenderRepaintBoundary boundary = RollaLinks.globalKeys[index].currentContext
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final directory = (await getApplicationDocumentsDirectory()).path;

    File imgFile = new File('$directory/$rollaId.png');
    print(imgFile.path);
    imgFile.writeAsBytes(pngBytes);
  }
}
