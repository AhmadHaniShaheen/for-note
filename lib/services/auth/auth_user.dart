import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerify;
  const AuthUser({required this.isEmailVerify});

  factory AuthUser.formFirebase(User user) => AuthUser(isEmailVerify: user.emailVerified);
}
