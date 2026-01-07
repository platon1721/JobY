import 'package:joby/state/auth/backend/authenticator.dart';
import 'package:joby/state/auth/models/auth_result.dart';
import 'package:joby/state/auth/models/auth_state.dart';
import 'package:joby/state/user_info/backend/user_info_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_provider.g.dart';

@riverpod
class Authentication extends _$Authentication {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  @override
  AuthState build() {
   if(_authenticator.isAlreadyLoggedIn) {
     return AuthState(
       result: AuthResult.success,
       isLoading: false,
       userId: _authenticator.userId,
      );
   }
   return AuthState.unknown();
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, result: null);
    await Future.delayed(const Duration(seconds: 3));
    final result = await _authenticator.loginWithEmailAndPassword(email, password);

    state = AuthState(
      isLoading: false,
      result: result,
      userId: _authenticator.userId,
    );
  }

  Future<void> logOut() async {
    await _authenticator.logOut();
    state = AuthState.unknown();
  }

  Future<void> registerWithEmailAndPassword(
      {required String email, required String password, required String name}) async {
    state = state.copyWith(isLoading: true);

    final result = await _authenticator.registerWithEmailAndPassword(
        email, password);

    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      print('Saving user info');
      saveUserInfo(userId, email, name);
    }

    state = AuthState(
      isLoading: false,
      result: result,
      userId: _authenticator.userId,
    );
  }

  Future<void> saveUserInfo(String userId, String email, String name) {
    return _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: name,
        email: email,
    );
  }
}
