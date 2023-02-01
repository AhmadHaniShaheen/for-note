import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fornote/firebase_options.dart';
import 'package:fornote/screens/login_screen.dart';
import 'package:fornote/screens/register_screen.dart';
import 'package:fornote/screens/verify_email_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const LoginScreen(),
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
              print(user);
              if (user.emailVerified) {
                print('your Email is verified');
              } else {
                const VerifyEmailScreen();
              }
            } else {
              const LoginScreen();
            }
            return const Placeholder(
              child: Text('Done'),
            );

          default:
            return const Text('loading');
        }
      },
    );
  }
}
