import 'package:firebase_auth/firebase_auth.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:joby/features/auth/domain/use_cases/login_with_email_password_use_case.dart';
import 'package:joby/features/auth/domain/use_cases/register_use_case.dart';
import 'package:joby/features/auth/domain/use_cases/send_password_reset_email_use_case.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/auth/presentation/providers/auth_providers.dart';

part 'auth_controller.g.dart';

/// Auth controller managing authentication state
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    // Listen to auth state changes
    _listenToAuthChanges();

    // Check initial auth state
    _checkInitialAuthState();

    return const AuthState.initial();
  }

  /// Listen to Firebase auth state changes
  void _listenToAuthChanges() {
    final authStateChangesUseCase = ref.read(authStateChangesUseCaseProvider);

    authStateChangesUseCase().listen((user) {
      if (state is AuthStateError || state is AuthStateLoading) {
        return;
      }
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  /// Check initial authentication state
  Future<void> _checkInitialAuthState() async {
    final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);

    final result = await getCurrentUserUseCase();

    result.fold((error) => state = AuthState.error(error.toString()), (user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  /// Login with email and password
  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final loginUseCase = ref.read(loginWithEmailPasswordUseCaseProvider);

    final result = await loginUseCase(
      LoginWithEmailPasswordParams(email: email, password: password),
    );

    result.fold(
      (error) => state = AuthState.error(error.toString()),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthState.loading();

    final registerUseCase = ref.read(registerUseCaseProvider);

    final result = await registerUseCase(
      RegisterParams(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );

    result.fold((error) {
      final errorMessage = _getErrorMessage(error).toString();
      state = AuthState.error(errorMessage);
    }, (user) => state = AuthState.authenticated(user));
  }

  Exception _getErrorMessage(Exception error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return AuthException('The account already exists for that email.');
        case 'weak-password':
          return AuthException('The password provided is too weak.');
        case 'invalid-email':
          return AuthException('The email address is not valid.');
        case 'too-many-requests':
          return AuthException('Too many requests. Please try again later.');
        case 'network-request-failed':
          return NetworkException(
            'Network error. Please check your connection.',
          );
        case 'user-disabled':
          return AuthException('This user has been disabled.');
        case 'invalid-credential':
          return AuthException('The provided credential is invalid.');
        default:
          return AuthException('An unknown error occurred. Please try again.');
      }
    } else {
      return error;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    state = const AuthState.loading();

    final logoutUseCase = ref.read(logoutUseCaseProvider);

    final result = await logoutUseCase();

    result.fold(
      (error) => state = AuthState.error(error.toString()),
      (_) => state = const AuthState.unauthenticated(),
    );
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    final sendResetEmailUseCase = ref.read(
      sendPasswordResetEmailUseCaseProvider,
    );

    final result = await sendResetEmailUseCase(
      SendPasswordResetEmailParams(email: email),
    );

    result.fold((error) => state = AuthState.error(error.toString()), (_) {
      // Keep current state, just show success message
    });
  }

  /// Clear error state
  void clearError() {
    if (state is AuthStateError) {
      state = const AuthState.unauthenticated();
    }
  }
}
