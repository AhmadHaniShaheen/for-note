import 'package:bloc/bloc.dart';
import 'package:fornote/services/auth/auth_provider.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventIntialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLogOut(null));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedVerification());
        } else {
          emit(AuthStateLogedIn(user));
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        // final password = event.password;
        try {
          final email = event.email;
          final password = event.password;
          final user = await provider.logIn(email: email, password: password);
          emit(AuthStateLogedIn(user));
        } on Exception catch (e) {
          emit(AuthStateLogOut(e));
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          emit(const AuthStateLoading());
          await provider.logOut();
          emit(const AuthStateLogOut(null));
        } on Exception catch (e) {
          emit(AuthStateLogedOutFailure(e));
        }
      },
    );
  }
}
