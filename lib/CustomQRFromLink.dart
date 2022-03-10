import 'dart:core';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
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
  Color pickerColor = Color(int.parse(defaultHex, radix: 16));
  XFile? pickedFile;

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
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
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
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );

                            if (result != null && result.files.isNotEmpty) {
                              final fileBytes = result.files.first.bytes;
                              if (fileBytes != null) {
                                setState(() {
                                  pickedFile = XFile.fromData(fileBytes);
                                });
                              }
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: Text("Pick file"),
                          color: Colors.blue,
                        ),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              pickedFile = null;
                            });
                          },
                          child: Text("Clear file"),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // FutureBuilder<Uint8List>(
          //     future: pickedFile?.readAsBytes(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return Image.memory(snapshot.data!);
          //       }
          //       return SizedBox();
          //     }),
          Center(
            child: RepaintBoundary(
              key: globalKey,
              child: QR(
                message: linkTextEditingController.text,
                color: color,
                file: pickedFile,
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
