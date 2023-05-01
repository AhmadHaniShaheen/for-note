import 'package:fornote/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState {
  final bool isLoading;
  final String? loadingText;

  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AuthStateUnintialized extends AuthState {
  const AuthStateUnintialized({required bool isLoading})
      : super(
          isLoading: isLoading,
        );
}

// class AuthStateRegistering extends AuthState {
//   final Exception? exception;
//   const AuthStateRegistering({
//     required this.exception,
//     required isLoading,
//   }) : super(isLoading: isLoading);
// }
class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSendEmail;
  const AuthStateForgotPassword({
    required this.hasSendEmail,
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLogedIn extends AuthState {
  final AuthUser user;
  const AuthStateLogedIn({required this.user, required isLoading})
      : super(isLoading: isLoading);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification({required isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLogOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLogOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}
