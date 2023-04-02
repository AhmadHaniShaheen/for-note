import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final option = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: option.keys.map((optionTitle) {
          final vlaue = option[optionTitle];
          return TextButton(
              onPressed: () {
                if (vlaue != null) {
                  Navigator.of(context).pop(vlaue);
                } else {
                  Navigator.of(context);
                }
              },
              child: Text(optionTitle));
        }).toList(),
      );
    },
  );
}
