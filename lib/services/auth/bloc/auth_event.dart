abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegistering extends AuthEvent {
  final String email;
  final String password;

  AuthEventRegistering(this.email, this.password);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventIntialize extends AuthEvent {
  const AuthEventIntialize();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;

  AuthEventForgotPassword({
    this.email,
  });
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
