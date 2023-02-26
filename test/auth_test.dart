import 'package:flutter_test/flutter_test.dart';
import 'package:fornote/services/auth/auth_exceptions.dart';
import 'package:fornote/services/auth/auth_provider.dart';
import 'package:fornote/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitalizeExceptin>()),
      );
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.register(
        email: 'foo@bar.com',
        password: 'anypassword',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.register(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.register(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerify, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerify, true);
    });
    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitalizeExceptin implements Exception {}

class MockAuthProvider implements AuthProvider {
  // AuthUser? _user;
  // bool _isInitialized = false;

  // bool get isInstialize => _isInitialized;

  // @override
  // Future<AuthUser> register(
  //     {required String email, required String password}) async {
  //   if (!isInstialize) throw NotInitalizeExceptin();
  //   return logIn(email: email, password: password);
  // }

  // @override
  // AuthUser? get currentUser => _user;

  // @override
  // Future<void> firebaseInitializ() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   _isInitialized = true;
  // }

  // @override
  // Future<AuthUser> logIn(
  //     {required String email, required String password}) async {
  //   if (!isInstialize) throw NotInitalizeExceptin();
  //   if (email == 'ahmad@shaheen.com') throw UserNotFoundAuthException();
  //   if (email == 'ahmadshaheen') throw WrongPasswordAuthException();
  //   const user = AuthUser(isEmailVerify: false);
  //   _user = user;
  //   return Future.value(user);
  // }

  // @override
  // Future<void> logOut() async {
  //   if (!isInstialize) throw NotInitalizeExceptin();
  //   if (_user == null) throw UserNotFoundAuthException();
  //   await Future.delayed(const Duration(seconds: 2));
  //   _user == null;
  // }

  // @override
  // Future<void> verifyEmail() async {
  //   if (!isInstialize) throw NotInitalizeExceptin;
  //   final user = _user;
  //   if (user == null) throw UserNotFoundAuthException();
  //   const newUser = AuthUser(isEmailVerify: true);
  //   _user = newUser;
  // }

  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitalizeExceptin();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerify: false, email: 'foo@bar.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitalizeExceptin();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> register(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitalizeExceptin();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitalizeExceptin();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerify: true, email: 'foobar@gmail.com');
    _user = newUser;
  }
}
