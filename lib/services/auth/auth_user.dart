import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerify;
  const AuthUser({required this.email, required this.isEmailVerify});

  factory AuthUser.formFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerify: user.emailVerified,
      );
}
