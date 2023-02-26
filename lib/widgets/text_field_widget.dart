import 'package:flutter/material.dart';

Widget textFormField({
  required TextInputType keyboardT,
  required bool obscureText,
  required bool autocorrect,
  required bool suggestions,
  required String hintText,
  required Icon textFieldIcon,
  required TextEditingController controller,
  required validator,
  IconData? suffix,
  Function()? suffixPressed,
}) =>
    TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardT,
      obscureText: obscureText,
      obscuringCharacter: '*',
      enableSuggestions: suggestions,
      autocorrect: autocorrect,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hintText,
        prefixIcon: textFieldIcon,
        suffixIcon: IconButton(onPressed: suffixPressed, icon: Icon(suffix)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xff09C2B5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xff09C2B5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
