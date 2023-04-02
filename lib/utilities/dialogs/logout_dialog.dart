import 'package:flutter/material.dart';
import 'package:fornote/utilities/dialogs/genric_dialog.dart';

Future<bool> showLogoutDialog({
  required BuildContext context,
  required String content,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: content,
    optionBuilder: () => {
      'Cancel': false,
      'Sure': true,
    },
  ).then((value) => value ?? false);
}
