import 'package:fornote/services/auth/auth_user.dart';

abstract class AuthProvider {
<<<<<<< HEAD
  Future<void> initialize();
=======
  Future<void> firebaseInitializ();
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
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
<<<<<<< HEAD
  Future<void> sendEmailVerification();
=======
  Future<void> verifyEmail();
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
}
