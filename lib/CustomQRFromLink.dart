import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:qr_code_generator/QR.dart';
import 'package:qr_code_generator/utils/save_image.dart';

import 'app/MyTextField.dart';

class CustomQRFromLink extends StatefulWidget {
  @override
  _CustomQRFromLinkState createState() => _CustomQRFromLinkState();
}

class _CustomQRFromLinkState extends State<CustomQRFromLink> with SaveImage {
  final GlobalKey globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  static const defaultHex = "FF111111";
  Color color = Color(int.parse(defaultHex, radix: 16));

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  final TextEditingController linkTextEditingController =
      TextEditingController();
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController colorTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    linkTextEditingController.dispose();
    nameTextEditingController.dispose();
    colorTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextFormField(
                      textEditingController: colorTextEditingController,
                      hint: 'Enter HEX color',
                      onChanged: (newValue) {
                        setState(() {
                          color = Color(
                            int.tryParse("FF$newValue", radix: 16) ??
                                int.parse(defaultHex, radix: 16),
                          );
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: MaterialButton(
                        height: 100,
                        color: color,
                        minWidth: double.infinity,
                        onPressed: () {
                          void changeColor(Color color) {
                            setState(() => pickerColor = color);
                          }

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('Pick'),
                                    onPressed: () {
                                      setState(() => color = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("or tap to pick"),
                      ),
                    ),
                    Text("Value: ${color.value.toRadixString(16)}"),
                  ],
                ),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              MyTextFormField(
                                textEditingController:
                                    linkTextEditingController,
                                hint: 'Enter QR code link',
                              ),
                              const SizedBox(height: 20),
                              MyTextFormField(
                                textEditingController:
                                    nameTextEditingController,
                                hint: 'Enter QR code image name',
                              ),
                            ],
                          ),
                        ),
                        MaterialButton(
                          height: 100,
                          onPressed: () {
                            final currentState = _formKey.currentState;
                            if (currentState != null &&
                                _formKey.currentState!.validate()) {
                              setState(() {});
                            }
                          },
                          child: Text("Generate QR code"),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RepaintBoundary(
                    key: globalKey,
                    child: QR(
                      message: linkTextEditingController.text,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          final currentState = _formKey.currentState;
          if (currentState != null && _formKey.currentState!.validate()) {
            saveImage(
              globalKey: globalKey,
              title: nameTextEditingController.text,
              context: context,
            );
          }
        },
        child: const Text('Save'),
      ),
    );
  }
}
