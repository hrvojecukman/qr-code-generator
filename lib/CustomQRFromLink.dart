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

import 'app/MyTextField.dart';

class CustomQRFromLink extends StatefulWidget {
  @override
  _CustomQRFromLinkState createState() => _CustomQRFromLinkState();
}

class _CustomQRFromLinkState extends State<CustomQRFromLink> {
  final GlobalKey globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _capturePng(
              globalKey,
              "Gift_10€",
            );
          }
        },
        child: const Text('Save'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MyTextFormField(
                  formKey: _formKey,
                  textEditingController: textEditingController,
                ),
              ),
              MaterialButton(
                onPressed: () => setState(() {}),
                child: Text("Generate QR code"),
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 20),
          RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: QR(
                message: textEditingController.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePng(GlobalKey globalKey, String title) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final directory = (await getApplicationDocumentsDirectory()).path;

    File imgFile = new File('$directory/$title.png');
    print(imgFile.path);
    imgFile.writeAsBytes(pngBytes);
  }
}
