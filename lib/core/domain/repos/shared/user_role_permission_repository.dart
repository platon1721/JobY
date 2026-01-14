import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/permission_entity.dart';
import 'package:joby/core/domain/entities/user_role_entity.dart';
import 'package:joby/core/domain/entities/user_role_permission_entity.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_role_permission_id.dart';

/// Abstract repository for UserRolePermission operations
/// Junction table: manages relationships between roles and permissions
abstract class UserRolePermissionRepository {
  /// Get all role-permission assignments
  Future<Either<Exception, List<UserRolePermissionEntity>>> getAllRolePermissions();

  /// Get role-permission assignment by ID
  Future<Either<Exception, UserRolePermissionEntity>> getRolePermissionById(
    UserRolePermissionId id,
  );

  /// Get all permissions for a specific role
  Future<Either<Exception, List<PermissionEntity>>> getPermissionsForRole(
    UserRoleId roleId,
  );

  /// Get all roles that have a specific permission
  Future<Either<Exception, List<UserRoleEntity>>> getRolesWithPermission(
    PermissionId permissionId,
  );

  /// Assign permission to role
  Future<Either<Exception, UserRolePermissionEntity>> assignPermissionToRole({
    required UserRoleId roleId,
    required PermissionId permissionId,
    required UserId createdBy,
  });

  /// Remove permission from role (set activeTill)
  Future<Either<Exception, void>> removePermissionFromRole({
    required UserRoleId roleId,
    required PermissionId permissionId,
  });

  /// Check if role has specific permission
  Future<Either<Exception, bool>> roleHasPermission({
    required UserRoleId roleId,
    required PermissionId permissionId,
  });

  /// Bulk assign permissions to role
  Future<Either<Exception, List<UserRolePermissionEntity>>> assignPermissionsToRole({
    required UserRoleId roleId,
    required List<PermissionId> permissionIds,
    required UserId createdBy,
  });

  /// Remove all permissions from role
  Future<Either<Exception, void>> removeAllPermissionsFromRole({
    required UserRoleId roleId,
    required DateTime deactivationDate,
  });
}
