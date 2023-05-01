import 'package:bloc/bloc.dart';
import 'package:fornote/services/auth/auth_provider.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUnintialized(isLoading: true)) {
    on<AuthEventIntialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLogOut(exception: null, isLoading: false));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedVerification(isLoading: false));
        } else {
          emit(AuthStateLogedIn(user: user, isLoading: false));
        }
      },
    );
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });
    on<AuthEventRegistering>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateNeedVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLogOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while I log you in',
        ));
        await Future.delayed(const Duration(seconds: 3));
        try {
          final email = event.email;
          final password = event.password;
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateLogOut(exception: null, isLoading: false));
            emit(const AuthStateNeedVerification(isLoading: false));
          } else {
            emit(const AuthStateLogOut(exception: null, isLoading: false));
            emit(AuthStateLogedIn(user: user, isLoading: false));
          }
        } on Exception catch (e) {
          emit(AuthStateLogOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLogOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLogOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    on<AuthEventForgotPassword>(((event, emit) async {
      emit(const AuthStateForgotPassword(
          hasSendEmail: false, exception: null, isLoading: false));

      final email = event.email;
      if (email == null) {
        return;
      }
      emit(const AuthStateForgotPassword(
          hasSendEmail: false, exception: null, isLoading: true));

      bool didSentEmail;
      Exception? exception;
      try {
        await provider.sendPasswordRest(toEmail: email);
        didSentEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSentEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
          hasSendEmail: didSentEmail, exception: exception, isLoading: false));
    }));
  }
}
