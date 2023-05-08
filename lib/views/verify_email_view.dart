import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fornote/services/auth/auth_service.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 62),
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
                      context.read<AuthBloc>().add(const AuthEventLogOut());
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
                  'Verify your email',
                  style: GoogleFonts.urbanist(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                'we\'ve sent to you email to verify your email, cleck to Veriry, then go back to Login view',
                style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff8391A1)),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                "if you doe's not reseve an email, click to this button to send Verification code",
                style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff8391A1)),
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff09C2B5),
                    minimumSize: const Size(double.infinity, 46)),
                onPressed: () async {
                  AuthService.firebase().sendEmailVerification();
                },
                child: const Text('send email to Verifyication again'),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
