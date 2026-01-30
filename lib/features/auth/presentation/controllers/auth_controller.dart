import 'package:firebase_auth/firebase_auth.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/features/users/domain/use_cases/create_user_use_case.dart';
import 'package:joby/features/users/presentation/providers/user_providers.dart';
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
    _listenToAuthChanges();
    _checkInitialAuthState();

    return const AuthState.initial();
  }

  void _listenToAuthChanges() {
    final authStateChangesUseCase = ref.read(authStateChangesUseCaseProvider);

    authStateChangesUseCase().listen((user) {

      if (state is AuthStateError || state is AuthStateLoading || state is AuthStateRegistering) {
        return;
      }
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

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

  /// Login with Google
  Future<void> loginWithGoogle() async {
    state = const AuthState.loading();

    final loginWithGoogleUseCase = ref.read(loginWithGoogleUseCaseProvider);
    final createUserUseCase = ref.read(createUserUseCaseProvider);
    final userRepository = ref.read(userRepositoryProvider);

    final result = await loginWithGoogleUseCase();

    await result.fold(
          (error) async {
        state = AuthState.error(error.toString());
      },
          (authUser) async {

        final existingUser = await userRepository.getUserById(authUser.uid);

        await existingUser.fold(
              (error) async {

            final names = (authUser.displayName ?? 'User').split(' ');
            final firstName = names.first;
            final surName = names.length > 1 ? names.sublist(1).join(' ') : '';

            final userResult = await createUserUseCase(
              CreateUserParams(
                userId: authUser.uid,
                firstName: firstName,
                surName: surName,
                email: authUser.email,
                createdBy: authUser.uid,
              ),
            );

            userResult.fold(
                  (error) {
                state = AuthState.error('User creation failed: $error');
              },
                  (user) {
                state = AuthState.authenticated(authUser);
              },
            );
          },
              (user) async {
            state = AuthState.authenticated(authUser);
          },
        );
      },
    );
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String surName,
    String? displayName,
  }) async {
    state = const AuthState.loading();

    final registerUseCase = ref.read(registerUseCaseProvider);
    final createUserUseCase = ref.read(createUserUseCaseProvider);

    final result = await registerUseCase(
      RegisterParams(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );

    await result.fold(
          (error) async {
        final errorMessage = _getErrorMessage(error).toString();
        state = AuthState.error(errorMessage);
      },
          (authUser) async {

        final userResult = await createUserUseCase(
          CreateUserParams(
            userId: authUser.uid,
            firstName: firstName,
            surName: surName,
            email: email,
            createdBy: authUser.uid,
          ),
        );

        userResult.fold(
              (error) {
            state = AuthState.error('User creation failed: $error');
          },
              (user) {
            state = AuthState.authenticated(authUser);
          },
        );
      },
    );
  }

  void completeRegistration() {
    if (state is AuthStateRegistering) {
      final user = (state as AuthStateRegistering).user;
      state = AuthState.authenticated(user);
    }
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

  /// Logout
  Future<void> logout() async {
    state = const AuthState.loading();

    final logoutUseCase = ref.read(logoutUseCaseProvider);

    final result = await logoutUseCase();

    result.fold(
          (error) => state = AuthState.error(error.toString()),
          (_) => state = const AuthState.unauthenticated(),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final sendResetEmailUseCase = ref.read(
      sendPasswordResetEmailUseCaseProvider,
    );

    final result = await sendResetEmailUseCase(
      SendPasswordResetEmailParams(email: email),
    );

    result.fold((error) => state = AuthState.error(error.toString()), (_) {
    });
  }

  void clearError() {
    if (state is AuthStateError) {
      state = const AuthState.unauthenticated();
    }
  }
}