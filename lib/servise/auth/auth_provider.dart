import 'package:fornote/servise/auth/auth_user.dart';

abstract class AuthProvider {
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
