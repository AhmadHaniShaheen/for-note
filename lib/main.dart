<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/firebase_options.dart';
import 'package:fornote/views/login_view.dart';
import 'package:fornote/views/notes/new_note_view.dart';
import 'package:fornote/views/notes/notes_view.dart';
import 'package:fornote/views/register_view.dart';
import 'package:fornote/views/verify_email_view.dart';
import 'dart:developer' as devtool show log;
=======
import 'package:flutter/material.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/secreens/login_screen.dart';
import 'package:fornote/secreens/notes_screen.dart';
import 'package:fornote/secreens/register_screen.dart';
import 'package:fornote/secreens/verify_email_screen.dart';
import 'package:fornote/services/auth/firebase_auth_services.dart';
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b

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
<<<<<<< HEAD
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        noteRoute: (context) => const NoteView(),
        newNoteRoute: (context) => const NewNoteVIew(),
=======
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        verifyEmailRoute: (context) => const VerifyEmailScreen(),
        noteRoute: (context) => const NoteScreen(),
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
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
<<<<<<< HEAD
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NoteView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
=======
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
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
        }
      },
    );
  }
}
<<<<<<< HEAD

enum MenuAction {
  logOut,
}

Future<bool> logOutDilog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you wont to log out? '),
        actions: [
          TextButton(
            onPressed: () {
              devtool.log('false');
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              devtool.log('true');
              Navigator.of(context).pop(true);
            },
            child: const Text('Sure'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
