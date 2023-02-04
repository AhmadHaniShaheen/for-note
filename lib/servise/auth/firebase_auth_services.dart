import 'package:fornote/servise/auth/auth_provider.dart';
import 'package:fornote/servise/auth/auth_user.dart';

class FirebaseAuthServices implements AuthProvider {
  final AuthProvider provider;

  FirebaseAuthServices(this.provider);

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
}
