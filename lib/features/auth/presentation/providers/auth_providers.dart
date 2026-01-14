import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// DATA LAYER
import 'package:joby/features/auth/data/repos/firebase_auth_repository.dart';

// DOMAIN LAYER
import 'package:joby/features/auth/domain/repos/auth_repository.dart';
import 'package:joby/features/auth/domain/use_cases/auth_state_changes_use_case.dart';
import 'package:joby/features/auth/domain/use_cases/get_current_user_use_case.dart';
import 'package:joby/features/auth/domain/use_cases/login_with_email_password_use_case.dart';
import 'package:joby/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:joby/features/auth/domain/use_cases/register_use_case.dart';
import 'package:joby/features/auth/domain/use_cases/send_password_reset_email_use_case.dart';

part 'auth_providers.g.dart';

// Firebase Auth instance
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

// Auth Repository
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
}

// Use Cases
@riverpod
LoginWithEmailPasswordUseCase loginWithEmailPasswordUseCase(Ref ref) {
  return LoginWithEmailPasswordUseCase(
    ref.watch(authRepositoryProvider),
  );
}

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(
    ref.watch(authRepositoryProvider),
  );
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(
    ref.watch(authRepositoryProvider),
  );
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(
    ref.watch(authRepositoryProvider),
  );
}

@riverpod
AuthStateChangesUseCase authStateChangesUseCase(Ref ref) {
  return AuthStateChangesUseCase(
    ref.watch(authRepositoryProvider),
  );
}

@riverpod
SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase(Ref ref) {
  return SendPasswordResetEmailUseCase(
    ref.watch(authRepositoryProvider),
  );
}