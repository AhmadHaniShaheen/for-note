import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/firebase_options.dart';
import 'package:fornote/widgets/text_field_widget.dart';
import 'dart:developer' as devtool show log;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        return Scaffold(
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

                          try {
                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            devtool.log(userCredential.toString());
                          } on FirebaseException catch (e) {
                            if (e.code == 'unknown') {
                              devtool.log('The Email & Password is requred');
                            } else if (e.code == 'weak-password') {
                              devtool.log('this is a weak-password');
                            } else if (e.code == 'email-already-in-use') {
                              devtool.log('email already in use');
                            } else if (e.code == 'invalid-email') {
                              devtool.log('invalid email');
                            } else {
                              devtool.log('Error is ${e.code}');
                            }
                          }
                        },
                        child: const Text('Register'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, loginRoute);
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
        );
      },
    );
  }
}
