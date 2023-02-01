import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fornote/firebase_options.dart';
import 'package:fornote/screens/login_screen.dart';
import 'package:fornote/screens/register_screen.dart';
import 'package:fornote/screens/verify_email_screen.dart';
import 'dart:developer' as devtool show log;

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
        '/login_screen': (context) => const LoginScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        '/verify_email_screen': (context) => const VerifyEmailScreen(),
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
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              devtool.log(user.toString());
              if (user.emailVerified) {
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

enum MenuAction {
  logOut,
}

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  child: const Text('Log out'),
                  value: MenuAction.logOut,
                ),
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logOut:
                  final shouldLogout = await logOutDilog(context);
                  if (shouldLogout) {
                    FirebaseAuth.instance.signOut();
                    Future.delayed(
                      const Duration(seconds: 0),
                      () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login_screen', (_) => false);
                      },
                    );
                  }
                  break;
              }
            },
          )
        ],
      ),
      body: const Text('Hello word'),
    );
  }
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
