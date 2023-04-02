import 'package:fornote/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState {
  const AuthState();
}

class AuthStateUnintialized extends AuthState {
  const AuthStateUnintialized();
}


class AuthStateRegistering extends AuthState {
  final Exception exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateLogedIn extends AuthState {
  final AuthUser user;
  const AuthStateLogedIn(this.user);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateLogOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLogOut(this.exception, this.isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}
