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

@riverpod
UserRepository userRepository(Ref ref) {
  return FirebaseUserRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
GetUserByIdUseCase getUserByIdUseCase(Ref ref) {
  return GetUserByIdUseCase(ref.watch(userRepositoryProvider));
}

@riverpod
GetAllUsersUseCase getAllUsersUseCase(Ref ref) {
  return GetAllUsersUseCase(ref.watch(userRepositoryProvider));
}

@riverpod
CreateUserUseCase createUserUseCase(Ref ref) {
  return CreateUserUseCase(ref.watch(userRepositoryProvider));
}

@riverpod
UpdateUserUseCase updateUserUseCase(Ref ref) {
  return UpdateUserUseCase(ref.watch(userRepositoryProvider));
}

@riverpod
DeactivateUserUseCase deactivateUserUseCase(Ref ref) {
  return DeactivateUserUseCase(ref.watch(userRepositoryProvider));
}

@riverpod
GetUsersByDepartmentUseCase getUsersByDepartmentUseCase(Ref ref) {
  return GetUsersByDepartmentUseCase(ref.watch(userRepositoryProvider));
}