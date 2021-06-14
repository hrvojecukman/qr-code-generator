import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final GlobalKey<FormState> formKey;

  // final Color color;
  // final Color errorTextColor;

  const MyTextFormField({
    Key key,
    this.textEditingController,
    this.formKey,
  });

  // this.color = Colors.blue,
  // this.errorTextColor = Colors.red})

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: textEditingController,
        // cursorColor: color,
        // style: AppTextStyles.rubikRegular(color),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          // fillColor: color.withOpacity(0.12),
          filled: true,
          border: InputBorder.none,
          hintText: "Enter text",
          // hintStyle: AppTextStyles.rubikRegular(color),
          // errorStyle: TextStyle().rubikRegular(errorTextColor),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return "Can't be empty";
          }

          return null;
        },
      ),
    );
  }
}
