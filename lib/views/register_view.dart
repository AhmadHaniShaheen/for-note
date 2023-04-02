import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fornote/services/auth/auth_exceptions.dart';
import 'package:fornote/services/auth/bloc/auth_bloc.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';
import 'package:fornote/utilities/show_snackbar_error.dart';
import 'package:fornote/widgets/text_field_widget.dart';
// import 'dart:developer' as devtool show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                // key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 112,
                    ),
                    const Image(
                      image: AssetImage('images/logo.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Let's Get Started",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'create a new account',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    textFormField(
                      keyboardT: TextInputType.emailAddress,
                      obscureText: false,
                      autocorrect: true,
                      suggestions: true,
                      hintText: 'Enter your Email here',
                      textFieldIcon: const Icon(Icons.email),
                      controller: _email,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Please, Enter your Email';
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
                      obscureText: false,
                      autocorrect: false,
                      suggestions: false,
                      hintText: 'Enter your Email here',
                      textFieldIcon: const Icon(Icons.email),
                      controller: _password,
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Please, Enter your Email';
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
                              AuthEventRegistering(email, password),
                            );
                        context.read<AuthBloc>().add(
                              const AuthEventSendEmailVerification(),
                            );
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                      },
                      child: const Text(
                        'already have an acount, Login Now',
                        style: TextStyle(
                          color: Color.fromARGB(255, 55, 46, 46),
                        ),
                      ),
                    ),
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
