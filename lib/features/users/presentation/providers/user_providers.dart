import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:joby/core/providers/firebase_provider.dart';
import 'package:joby/features/users/data/repos/firebase_user_repository.dart';
import 'package:joby/features/users/domain/repos/user_repository.dart';
import 'package:joby/features/users/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:joby/features/users/domain/use_cases/get_all_users_use_case.dart';
import 'package:joby/features/users/domain/use_cases/create_user_use_case.dart';
import 'package:joby/features/users/domain/use_cases/update_user_use_case.dart';
import 'package:joby/features/users/domain/use_cases/deactivate_user_use_case.dart';
import 'package:joby/features/users/domain/use_cases/get_users_by_department_use_case.dart';

part 'user_providers.g.dart';

// ============================================================================
// REPOSITORY
// ============================================================================

/// Kasutaja repository - Firebase teostus
@riverpod
UserRepository userRepository(Ref ref) {
  return FirebaseUserRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

// ============================================================================
// USE CASES
// ============================================================================

/// Get user by ID use case
@riverpod
GetUserByIdUseCase getUserByIdUseCase(Ref ref) {
  return GetUserByIdUseCase(ref.watch(userRepositoryProvider));
}

/// Get all users use case
@riverpod
GetAllUsersUseCase getAllUsersUseCase(Ref ref) {
  return GetAllUsersUseCase(ref.watch(userRepositoryProvider));
}

/// Create user use case
@riverpod
CreateUserUseCase createUserUseCase(Ref ref) {
  return CreateUserUseCase(ref.watch(userRepositoryProvider));
}

/// Update user use case
@riverpod
UpdateUserUseCase updateUserUseCase(Ref ref) {
  return UpdateUserUseCase(ref.watch(userRepositoryProvider));
}

/// Deactivate user use case
@riverpod
DeactivateUserUseCase deactivateUserUseCase(Ref ref) {
  return DeactivateUserUseCase(ref.watch(userRepositoryProvider));
}

/// Get users by department use case
@riverpod
GetUsersByDepartmentUseCase getUsersByDepartmentUseCase(Ref ref) {
  return GetUsersByDepartmentUseCase(ref.watch(userRepositoryProvider));
}