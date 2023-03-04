import 'package:flutter/material.dart';
import 'package:fornote/utilities/dialogs/genric_dialogs.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String content,
}) {
  return showGenericDialog(
    context: context,
    title: 'an error occured',
    content: content,
    optionBuilder: () => {'ok': null},
  );
}
