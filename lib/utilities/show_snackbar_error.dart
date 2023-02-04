import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context,
    {required String message, bool? error}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error == true ? Colors.red : Colors.green,
    ),
  );
}
