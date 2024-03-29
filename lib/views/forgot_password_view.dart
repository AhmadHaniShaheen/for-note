import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fornote/extensions/build_contex/loc.dart';
import 'package:fornote/services/auth/bloc/auth_bloc.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';
import 'package:fornote/utilities/dialogs/error_dialog.dart';
import 'package:fornote/utilities/dialogs/sent_forgot_password_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/text_field_widget.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSendEmail) {
            _controller.clear();
            await sentForgotPasswordDialog(context: context);
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(
                context: context,
                // ignore: use_build_context_synchronously
                content: context.loc.forgot_password_view_generic_error);
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 62),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffE8ECF4),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.transparent,
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  context.loc.forgot_password,
                  style: GoogleFonts.urbanist(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                context.loc.forgot_password_description_view,
                style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff8391A1)),
              ),
              const SizedBox(
                height: 14,
              ),
              textFormField(
                keyboardT: TextInputType.emailAddress,
                obscureText: false,
                autocorrect: true,
                suggestions: true,
                autofocus: true,
                hintText: context.loc.email_text_field_placeholder,
                textFieldIcon: const Icon(Icons.email),
                controller: _controller,
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return context.loc.email_text_field_placeholder;
                  } else if (!value.contains("@") || !value.contains(".")) {
                    return context.loc.register_error_invalid_email;
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff09C2B5),
                    minimumSize: const Size(double.infinity, 46)),
                onPressed: () async {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(AuthEventForgotPassword(
                        email: email,
                      ));
                },
                child: Text(context.loc.password_reset),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff09C2B5),
                    minimumSize: const Size(double.infinity, 46)),
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: Text(context.loc.forgot_password_view_back_to_login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
