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

// ============================================================================
// JUNCTION TABLE REPOSITORIES (Shared/Cross-cutting)
// ============================================================================

/// UserUserRole repository (User ↔ Role relationship)
@riverpod
UserUserRoleRepository userUserRoleRepository(Ref ref) {
  return FirebaseUserUserRoleRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// UserRolePermission repository (Role ↔ Permission relationship)
@riverpod
UserRolePermissionRepository userRolePermissionRepository(Ref ref) {
  return FirebaseUserRolePermissionRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// DepartmentInDepartment repository (Department hierarchy)
@riverpod
DepartmentInDepartmentRepository departmentInDepartmentRepository(Ref ref) {
  return FirebaseDepartmentInDepartmentRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// DepartmentUser repository (Department ↔ User relationship)
@riverpod
DepartmentUserRepository departmentUserRepository(Ref ref) {
  return FirebaseDepartmentUserRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// DepartmentTypeInType repository (Type hierarchy rules)
@riverpod
DepartmentTypeInTypeRepository departmentTypeInTypeRepository(Ref ref) {
  return FirebaseDepartmentTypeInTypeRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

// ============================================================================
// SHARED SERVICES
// ============================================================================

/// Permission checker service
/// Requires UserUserRole, UserRolePermission, and Permission repositories
@riverpod
PermissionCheckerService permissionCheckerService(Ref ref) {
  // Note: PermissionRepository comes from permissions feature
  // This will be added when we create permissions feature providers
  return PermissionCheckerService(
    userUserRoleRepository: ref.watch(userUserRoleRepositoryProvider),
    userRolePermissionRepository: ref.watch(userRolePermissionRepositoryProvider),
    //permissionRepository: ref.watch(permissionRepositoryProvider), // TODO: Add when permissions feature has providers
  );
}
