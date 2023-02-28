import 'package:flutter/material.dart';
import 'package:fornote/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
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
