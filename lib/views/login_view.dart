import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/services/auth/auth_exceptions.dart';
import 'package:fornote/services/auth/bloc/auth_bloc.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';
import 'package:fornote/utilities/dialogs/error_dialog.dart';
import 'package:fornote/widgets/text_field_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                        context
                            .read<AuthBloc>()
                            .add(AuthEventLogIn(email, password));
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(registerRoute);
                      },
                      child: const Text(
                        'Don\'t have an acount, Register Now',
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
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fornote/constant/route.dart';
// import 'package:fornote/services/auth/auth_exceptions.dart';
// import 'package:fornote/services/auth/bloc/auth_bloc.dart';
// import 'package:fornote/services/auth/bloc/auth_event.dart';
// import 'package:fornote/services/auth/bloc/auth_state.dart';
// import 'package:fornote/utilities/dialogs/error_dialog.dart';
// import 'package:fornote/utilities/dialogs/loading_dialog.dart';
// import 'package:fornote/widgets/text_field_widget.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({Key? key}) : super(key: key);

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   late final TextEditingController _email;
//   late final TextEditingController _password;
//   CloseDialog? _closeDialogHandle;

//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthStateLogOut) {
//           final closeDialog = _closeDialogHandle;

//           if (!state.isLoading && closeDialog != null) {
//             closeDialog();
//             _closeDialogHandle = null;
//           } else if (state.isLoading && closeDialog == null) {
//             _closeDialogHandle = showLoadingDialog(
//               context: context,
//               text: 'Loading...',
//             );
//           }
//           if (state.exception is UserNotFoundAuthException) {
//             await showErrorDialog(context: context, content: 'User not found');
//           } else if (state.exception is WrongPasswordAuthException) {
//             await showErrorDialog(
//                 context: context, content: 'Wrong credentials');
//           } else if (state.exception is GenericAuthException) {
//             await showErrorDialog(
//                 context: context, content: 'Authentication error');
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Login'),
//         ),
//         body: Column(
//           children: [
//             TextField(
//               controller: _email,
//               enableSuggestions: false,
//               autocorrect: false,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your email here',
//               ),
//             ),
//             TextField(
//               controller: _password,
//               obscureText: true,
//               enableSuggestions: false,
//               autocorrect: false,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your password here',
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final email = _email.text;
//                 final password = _password.text;
//                 context.read<AuthBloc>().add(
//                       AuthEventLogIn(
//                         email,
//                         password,
//                       ),
//                     );
//               },
//               child: const Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 context.read<AuthBloc>().add(
//                       AuthEventShouldRegister(),
//                     );
//               },
//               child: const Text('Not registered yet? Register here!'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
