import 'package:flutter/material.dart';
import 'package:fornote/extensions/build_contex/loc.dart';
import 'package:fornote/utilities/dialogs/genric_dialog.dart';

Future<bool> showDeleteDialog({
  required BuildContext context,
  required String content,
}) {
  return showGenericDialog(
    context: context,
    title: context.loc.delete,
    content: content,
    optionBuilder: () => {
      context.loc.cancel: false,
      context.loc.yes: true,
    },
  ).then((value) => value ?? false);
}
