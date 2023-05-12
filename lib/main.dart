import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/helpers/loading/loading_screen.dart';
import 'package:fornote/services/auth/bloc/auth_bloc.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';
import 'package:fornote/services/auth/firebase_auth_provider.dart';
import 'package:fornote/views/forgot_password_view.dart';
import 'package:fornote/views/login_view.dart';
import 'package:fornote/views/notes/create_update_note_view.dart';
import 'package:fornote/views/notes/notes_view.dart';
import 'package:fornote/views/register_view.dart';
import 'package:fornote/views/verify_email_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'dart:developer' as devtool show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventIntialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLogedIn) {
          return const NoteView();
        } else if (state is AuthStateNeedVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLogOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
