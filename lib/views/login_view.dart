import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fornote/extensions/build_contex/loc.dart';
import 'package:fornote/services/auth/auth_exceptions.dart';
import 'package:fornote/services/auth/bloc/auth_bloc.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';
import 'package:fornote/utilities/dialogs/error_dialog.dart';
import 'package:fornote/widgets/text_field_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool showpassword = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLogOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context: context, content: 'User Not Found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context: context, content: 'wrong Credential');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
                context: context, content: 'Enter your Email and Password');
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_background.png'),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                // key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 112,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        context.loc.login_welecom,
                        style: GoogleFonts.urbanist(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    textFormField(
                      autofocus: true,
                      keyboardT: TextInputType.emailAddress,
                      obscureText: false,
                      autocorrect: true,
                      suggestions: true,
                      hintText: context.loc.email_text_field_placeholder,
                      textFieldIcon: const Icon(Icons.email),
                      controller: _email,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return context.loc.email_text_field_placeholder;
                        } else if (value.isNotEmpty && value.length < 4) {
                          return context.loc.email_text_field_short;
                        } else if (!value.contains("@") ||
                            !value.contains(".")) {
                          return context.loc.login_error_cannot_find_user;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    textFormField(
                      autofocus: false,
                      keyboardT: TextInputType.text,
                      obscureText: showpassword,
                      autocorrect: false,
                      suggestions: false,
                      hintText: context.loc.password_text_field_placeholder,
                      textFieldIcon: const Icon(Icons.email),
                      controller: _password,
                      suffix: Icons.remove_red_eye_sharp,
                      suffixPressed: () {
                        setState(() {
                          showpassword = !showpassword;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return context.loc.password_text_field_placeholder;
                        } else if (value.isNotEmpty && value.length < 4) {
                          return 'Please, your password is so short';
                        } else if (!value.contains("@") ||
                            !value.contains(".")) {
                          return 'Please, Enter a vaild password ';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthEventForgotPassword());
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          context.loc.forgot_password,
                          style: const TextStyle(
                            color: Color(
                              0xff6A707C,
                            ),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff09C2B5),
                          minimumSize: const Size(double.infinity, 46)),
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventLogIn(email, password));
                      },
                      child: Text(context.loc.login),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.loc.login_view_not_registered_yet,
                            style: GoogleFonts.urbanist(
                              color: const Color(0xff1E232C),
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    const AuthEventShouldRegister(),
                                  );
                            },
                            child: Text(
                              context.loc.register,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: const Color(0xff35C2C1),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
