import 'package:flutter/material.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/secreens/login_screen.dart';
import 'package:fornote/secreens/notes_screen.dart';
import 'package:fornote/secreens/register_screen.dart';
import 'package:fornote/secreens/verify_email_screen.dart';
import 'package:fornote/services/auth/firebase_auth_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const HomePage(),
      // initialRoute: '/login_screen',
      debugShowCheckedModeBanner: false,
      routes: {
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        verifyEmailRoute: (context) => const VerifyEmailScreen(),
        noteRoute: (context) => const NoteScreen(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      future: AuthService.firebase().firebaseInitializ(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerify) {
                return const NoteScreen();
              } else {
                return const VerifyEmailScreen();
              }
            } else {
              return const LoginScreen();
            }
          default:
            return const Text('loading');
        }
      },
    );
  }
}
