import 'package:joby/core/domain/entities/permission_entity.dart';
import 'package:joby/core/domain/entities/user_role_entity.dart';
import 'package:joby/core/domain/entities/user_role_permission_entity.dart';
import 'package:joby/core/domain/entities/user_user_role_entity.dart';
import 'package:joby/core/domain/enums/permission.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Service for checking user permissions
class PermissionChecker {
  /// Check if user has a specific permission
  ///
  /// Parameters:
  /// - [userId]: The user to check
  /// - [permission]: The permission to check for
  /// - [userRoles]: All user-role assignments
  /// - [rolePermissions]: All role-permission assignments
  /// - [permissions]: All available permissions
  ///
  /// Returns true if user has the permission through any of their active roles
  static bool hasPermission({
    required UserId userId,
    required Permission permission,
    required List<UserUserRoleEntity> userRoles,
    required List<UserRolePermissionEntity> rolePermissions,
    required List<PermissionEntity> permissions,
  }) {
    // Get user's active roles
    final activeUserRoles = userRoles
        .where((ur) => ur.userId == userId && ur.isActive)
        .map((ur) => ur.roleId)
        .toSet();

    if (activeUserRoles.isEmpty) {
      return false;
    }

    // Find the permission entity by code
    final permissionEntity = permissions.firstWhere(
          (p) => p.code == permission.code && p.isActive,
      orElse: () => throw Exception('Permission ${permission.code} not found'),
    );

    // Check if any of user's roles have this permission
    return rolePermissions.any((rp) =>
    activeUserRoles.contains(rp.roleId) &&
        rp.permissionId == permissionEntity.id &&
        rp.isActive);
  }

  /// Check if user has any of the specified permissions
  static bool hasAnyPermission({
    required UserId userId,
    required List<Permission> permissions,
    required List<UserUserRoleEntity> userRoles,
    required List<UserRolePermissionEntity> rolePermissions,
    required List<PermissionEntity> allPermissions,
  }) {
    return permissions.any((permission) => hasPermission(
      userId: userId,
      permission: permission,
      userRoles: userRoles,
      rolePermissions: rolePermissions,
      permissions: allPermissions,
    ));
  }

  /// Check if user has all of the specified permissions
  static bool hasAllPermissions({
    required UserId userId,
    required List<Permission> permissions,
    required List<UserUserRoleEntity> userRoles,
    required List<UserRolePermissionEntity> rolePermissions,
    required List<PermissionEntity> allPermissions,
  }) {
    return permissions.every((permission) => hasPermission(
      userId: userId,
      permission: permission,
      userRoles: userRoles,
      rolePermissions: rolePermissions,
      permissions: allPermissions,
    ));
  }

  /// Get all permissions for a user
  static Set<Permission> getUserPermissions({
    required UserId userId,
    required List<UserUserRoleEntity> userRoles,
    required List<UserRolePermissionEntity> rolePermissions,
    required List<PermissionEntity> allPermissions,
  }) {
    // Get user's active roles
    final activeUserRoles = userRoles
        .where((ur) => ur.userId == userId && ur.isActive)
        .map((ur) => ur.roleId)
        .toSet();

    if (activeUserRoles.isEmpty) {
      return {};
    }

    // Get permission IDs for these roles
    final permissionIds = rolePermissions
        .where((rp) => activeUserRoles.contains(rp.roleId) && rp.isActive)
        .map((rp) => rp.permissionId)
        .toSet();

    // Convert to Permission enum values
    final permissions = <Permission>{};
    for (final permissionId in permissionIds) {
      final permEntity = allPermissions.firstWhere(
            (p) => p.id == permissionId && p.isActive,
        orElse: () => throw Exception('Permission with id $permissionId not found'),
      );

      final permission = Permission.fromCode(permEntity.code);
      if (permission != null) {
        permissions.add(permission);
      }
    }

    return permissions;
  }
}