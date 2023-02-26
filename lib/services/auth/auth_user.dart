import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
<<<<<<< HEAD
  final String? email;
  final bool isEmailVerify;
  const AuthUser({required this.email, required this.isEmailVerify});

  factory AuthUser.formFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerify: user.emailVerified,
      );
=======
  final bool isEmailVerify;
  const AuthUser({required this.isEmailVerify});

  factory AuthUser.formFirebase(User user) => AuthUser(isEmailVerify: user.emailVerified);
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
}
