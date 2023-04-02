import 'package:flutter/material.dart';
import 'package:fornote/utilities/dialogs/genric_dialog.dart';

Future<void> cannotShareEmptyNoteDialog({required BuildContext context}) {
  return showGenericDialog(
    context: context,
    title: 'Sharing Error',
    content: 'You Can\'t Share an Empty Note',
    optionBuilder: () => {
      'ok': Null,
    },
  );
}
