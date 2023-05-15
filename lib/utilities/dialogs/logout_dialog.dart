import 'package:flutter/material.dart';
import 'package:fornote/utilities/dialogs/genric_dialog.dart';
import 'package:fornote/extensions/build_contex/loc.dart';

Future<bool> showLogoutDialog({
  required BuildContext context,
  required String content,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.logout_button,
    content: content,
    optionBuilder: () => {
      context.loc.cancel: false,
      context.loc.yes: true,
    },
  ).then((value) => value ?? false);
}
