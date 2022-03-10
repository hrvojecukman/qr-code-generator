import 'package:flutter/material.dart';
import 'package:qr_code_generator/CustomQRFromLink.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(body: CustomQRFromLink()),
    );
  }
}
