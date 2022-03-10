import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hint;
  final Function(String?)? onChanged;

  const MyTextFormField({
    required this.textEditingController,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        border: InputBorder.none,
        hintText: hint,
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return "Can't be empty";
        }

        return null;
      },
    );
  }
}
