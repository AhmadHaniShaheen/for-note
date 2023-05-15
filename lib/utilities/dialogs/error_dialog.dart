import 'package:flutter/material.dart';
import 'package:fornote/extensions/build_contex/loc.dart';
import 'package:fornote/utilities/dialogs/genric_dialog.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String content,
}) {
  return showGenericDialog(
    context: context,
    title: context.loc.generic_error_prompt,
    content: content,
    optionBuilder: () => {context.loc.ok: null},
  );
}
