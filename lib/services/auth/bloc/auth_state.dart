import 'package:fornote/services/auth/auth_user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLogedIn extends AuthState {
  final AuthUser user;
  const AuthStateLogedIn(this.user);
}


class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateLogOut extends AuthState {
  final Exception? exception;
  const AuthStateLogOut(this.exception);
}

class AuthStateLogedOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogedOutFailure(this.exception);
}

// Auth Event in new File.  
