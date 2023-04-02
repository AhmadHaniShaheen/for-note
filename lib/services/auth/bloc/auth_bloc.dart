import 'package:bloc/bloc.dart';
import 'package:fornote/services/auth/auth_provider.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUnintialized()) {
    on<AuthEventIntialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLogOut(null, false));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedVerification());
        } else {
          emit(AuthStateLogedIn(user));
        }
      },
    );
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );

    on<AuthEventRegistering>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateNeedVerification());
        } on Exception catch (e) {
          emit(AuthStateRegistering(e));
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLogOut(null, false));
        await Future.delayed(const Duration(seconds: 3));
        try {
          final email = event.email;
          final password = event.password;
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateLogOut(null, false));
            emit(const AuthStateNeedVerification());
          } else {
            emit(const AuthStateLogOut(null, false));
            emit(AuthStateLogedIn(user));
          }
        } on Exception catch (e) {
          emit(AuthStateLogOut(e, false));
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          emit(const AuthStateLogOut(null, false));
        } on Exception catch (e) {
          emit(AuthStateLogOut(e, false));
        }
      },
    );
  }
}
