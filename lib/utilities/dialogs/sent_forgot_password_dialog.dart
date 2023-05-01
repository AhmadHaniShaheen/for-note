import 'package:flutter/widgets.dart';
import 'package:fornote/utilities/dialogs/genric_dialog.dart';

Future<void> sentForgotPasswordDialog({required BuildContext context}) {
  return showGenericDialog(
      context: context,
      title: 'Reset Password',
      content:
          'We have now sent you a password reset link, please check your email',
      optionBuilder: () => {'ok': null});
}
