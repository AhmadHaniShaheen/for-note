import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fornote/services/auth/auth_exceptions.dart';
import 'package:fornote/services/auth/bloc/auth_bloc.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';
import 'package:fornote/utilities/show_snackbar_error.dart';
import 'package:fornote/widgets/text_field_widget.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:developer' as devtool show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  var showpassword = true;

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
      listener: (context, state) {
        if (state is AuthStateRegistering) {
          if (state.exception is EmailAndPasswordRequriedAuthException) {
            showErrorSnackbar(
              context,
              message: 'The Email & Password is requred',
              error: true,
            );
          } else if (state.exception is WeakPasswordAuthException) {
            showErrorSnackbar(
              context,
              message: 'this is a weak-password',
              error: true,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            showErrorSnackbar(
              context,
              message: 'email already in use',
              error: true,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            showErrorSnackbar(
              context,
              message: 'invalid email',
              error: true,
            );
          } else if (state.exception is GenericAuthException) {
            showErrorSnackbar(
              context,
              message: 'Authentcation Error',
              error: true,
            );
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 62),
              child: Form(
                // key: formKey,
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
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Hello! Register to get started',
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
                      keyboardT: TextInputType.emailAddress,
                      obscureText: false,
                      autocorrect: true,
                      suggestions: true,
                      hintText: 'Enter your email here',
                      textFieldIcon: const Icon(Icons.email),
                      controller: _email,
                      autofocus: true,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Please, Enter your email';
                        } else if (value.isNotEmpty && value.length < 4) {
                          return 'Please, your email is so short';
                        } else if (!value.contains("@") ||
                            !value.contains(".")) {
                          return 'Please, Enter a vaild email ';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    textFormField(
                      keyboardT: TextInputType.text,
                      obscureText: showpassword,
                      autocorrect: false,
                      autofocus: false,
                      suggestions: false,
                      hintText: 'Enter your password',
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
                          return 'Please, Enter your password';
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
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff09C2B5),
                          minimumSize: const Size(double.infinity, 46)),
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventRegistering(
                                email,
                                password,
                              ),
                            );
                        context.read<AuthBloc>().add(
                              const AuthEventSendEmailVerification(),
                            );
                      },
                      child: const Text('Register'),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.urbanist(
                              color: const Color(0xff1E232C),
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    const AuthEventLogOut(),
                                  );
                            },
                            child: Text(
                              'Login Now',
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
