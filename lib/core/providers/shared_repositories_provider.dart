import 'package:joby/features/permissions/presentation/providers/permissions_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:joby/core/providers/firebase_provider.dart';
import 'package:joby/core/domain/repos/shared/user_user_role_repository.dart';
import 'package:joby/core/data/repos/shared/firebase_user_user_role_repository.dart';
import 'package:joby/core/domain/repos/shared/user_role_permission_repository.dart';
import 'package:joby/core/data/repos/shared/firebase_user_role_permission_repository.dart';
import 'package:joby/core/domain/repos/shared/department_in_department_repository.dart';
import 'package:joby/core/data/repos/shared/firebase_department_in_department_repository.dart';
import 'package:joby/core/domain/repos/shared/department_user_repository.dart';
import 'package:joby/core/data/repos/shared/firebase_department_user_repository.dart';
import 'package:joby/core/domain/repos/shared/department_type_in_type_repository.dart';
import 'package:joby/core/data/repos/shared/firebase_department_type_in_type_repository.dart';
import 'package:joby/core/domain/services/permission_checker_service.dart';

part 'shared_repositories_provider.g.dart';

@riverpod
UserUserRoleRepository userUserRoleRepository(Ref ref) {
  return FirebaseUserUserRoleRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
UserRolePermissionRepository userRolePermissionRepository(Ref ref) {
  return FirebaseUserRolePermissionRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
DepartmentInDepartmentRepository departmentInDepartmentRepository(Ref ref) {
  return FirebaseDepartmentInDepartmentRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
DepartmentUserRepository departmentUserRepository(Ref ref) {
  return FirebaseDepartmentUserRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
DepartmentTypeInTypeRepository departmentTypeInTypeRepository(Ref ref) {
  return FirebaseDepartmentTypeInTypeRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
PermissionCheckerService permissionCheckerService(Ref ref) {
  return PermissionCheckerService(
    userUserRoleRepository: ref.watch(userUserRoleRepositoryProvider),
    userRolePermissionRepository: ref.watch(userRolePermissionRepositoryProvider),
    permissionRepository: ref.watch(permissionRepositoryProvider),
  );
}
