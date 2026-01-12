import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/permission_entity.dart';
import 'package:joby/core/domain/entities/user_role_entity.dart';
import 'package:joby/core/domain/entities/user_role_permission_entity.dart';
import 'package:joby/core/domain/entities/user_user_role_entity.dart';
import 'package:joby/core/domain/enums/permission.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';

/// Abstract repository for Permission operations
/// This handles complex permission checking across users, roles, and permissions
abstract class PermissionRepository {
  /// Get all permissions
  Future<Either<Exception, List<PermissionEntity>>> getAllPermissions();

  /// Get permission by ID
  Future<Either<Exception, PermissionEntity>> getPermissionById(
      PermissionId permissionId,
      );

  /// Get permission by code
  Future<Either<Exception, PermissionEntity>> getPermissionByCode(
      String code,
      );

  /// Get all roles
  Future<Either<Exception, List<UserRoleEntity>>> getAllRoles();

  /// Get role by ID
  Future<Either<Exception, UserRoleEntity>> getRoleById(
      UserRoleId roleId,
      );

  /// Get permissions for a specific role
  Future<Either<Exception, List<PermissionEntity>>> getPermissionsForRole(
      UserRoleId roleId,
      );

  /// Get roles for a user
  Future<Either<Exception, List<UserRoleEntity>>> getRolesForUser(
      UserId userId,
      );

  /// Get all permissions for a user (aggregated from all their roles)
  Future<Either<Exception, Set<Permission>>> getUserPermissions(
      UserId userId,
      );

  /// Check if user has specific permission
  Future<Either<Exception, bool>> userHasPermission({
    required UserId userId,
    required Permission permission,
  });

  /// Check if user has any of the specified permissions
  Future<Either<Exception, bool>> userHasAnyPermission({
    required UserId userId,
    required List<Permission> permissions,
  });

  /// Check if user has all of the specified permissions
  Future<Either<Exception, bool>> userHasAllPermissions({
    required UserId userId,
    required List<Permission> permissions,
  });

  /// Create new role
  Future<Either<Exception, UserRoleEntity>> createRole({
    required String name,
    required String description,
    required UserId createdBy,
  });

  /// Update role
  Future<Either<Exception, UserRoleEntity>> updateRole({
    required UserRoleId roleId,
    String? name,
    String? description,
  });

  /// Assign permission to role
  Future<Either<Exception, void>> assignPermissionToRole({
    required UserRoleId roleId,
    required PermissionId permissionId,
    required UserId createdBy,
  });

  /// Remove permission from role
  Future<Either<Exception, void>> removePermissionFromRole({
    required UserRoleId roleId,
    required PermissionId permissionId,
  });

  /// Assign role to user
  Future<Either<Exception, void>> assignRoleToUser({
    required UserId userId,
    required UserRoleId roleId,
    required UserId createdBy,
  });

  /// Remove role from user
  Future<Either<Exception, void>> removeRoleFromUser({
    required UserId userId,
    required UserRoleId roleId,
  });

  /// Deactivate role
  Future<Either<Exception, void>> deactivateRole({
    required UserRoleId roleId,
    required DateTime deactivationDate,
  });

  /// Get all user-role assignments
  Future<Either<Exception, List<UserUserRoleEntity>>> getAllUserRoles();

  /// Get all role-permission assignments
  Future<Either<Exception, List<UserRolePermissionEntity>>> getAllRolePermissions();
}