import 'package:flutter/material.dart';
import 'package:fornote/services/auth/firebase_auth_services.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Column(
        children: [
          const Text(
              "we've sent to you email to verify your email, cleck to Veriry"),
          const Text("if you doe's reseve an email, click to this button"),
          ElevatedButton(
            onPressed: () {
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Verify Email'),
          ),
        ],
      ),
    );
  }
}
