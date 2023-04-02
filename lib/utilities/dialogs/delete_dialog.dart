import 'package:flutter/material.dart';
import 'package:fornote/utilities/dialogs/genric_dialog.dart';

Future<bool> showDeleteDialog({
  required BuildContext context,
  required String content,
}) {
  return showGenericDialog(
    context: context,
    title: 'Delete Item',
    content: content,
    optionBuilder: () => {
      'Cancel': false,
      'Sure': true,
    },
  ).then((value) => value ?? false);
}
