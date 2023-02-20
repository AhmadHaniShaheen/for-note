import 'package:fornote/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> firebaseInitializ();
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> register({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> verifyEmail();
}