import 'package:fornote/services/auth/auth_provider.dart';
import 'package:fornote/services/auth/auth_user.dart';
import 'package:fornote/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> register(
          {required String email, required String password}) =>
      provider.register(email: email, password: password);

  @override
  Future<void> verifyEmail() => provider.verifyEmail();

  @override
  Future<void> firebaseInitializ() => provider.firebaseInitializ();
}
