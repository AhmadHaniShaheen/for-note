import 'package:firebase_auth/firebase_auth.dart';
import 'package:fornote/servise/auth/auth_exceptions.dart';
import 'package:fornote/servise/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthUser {
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (User != null) {
      return AuthUser.formFirebase(user!);
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unknown') {
        throw EmailAndPasswordRequriedAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        throw GeneralAuthException();
      }
    } catch (_) {
      throw GeneralAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unknown') {
        throw EmailAndPasswordRequriedAuthException();
      } else if (e.code == 'weak-password') {
        throw WeekPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GeneralAuthException();
      }
    } catch (e) {
      throw GeneralAuthException();
    }
  }

  @override
  Future<void> verifyEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  bool get isEmailVerify => throw UnimplementedError();
}
