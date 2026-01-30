import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/enums/permission.dart';
import 'package:joby/core/domain/repos/shared/user_role_permission_repository.dart';
import 'package:joby/core/domain/repos/shared/user_user_role_repository.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/permissions/domain/repos/permission_repository.dart';

class PermissionCheckerService {
  final UserUserRoleRepository _userUserRoleRepository;
  final UserRolePermissionRepository _userRolePermissionRepository;
  final PermissionRepository _permissionRepository;

  PermissionCheckerService({
    required UserUserRoleRepository userUserRoleRepository,
    required UserRolePermissionRepository userRolePermissionRepository,
    required PermissionRepository permissionRepository,
  })  : _userUserRoleRepository = userUserRoleRepository,
        _userRolePermissionRepository = userRolePermissionRepository,
        _permissionRepository = permissionRepository;

  Future<Either<Exception, Set<Permission>>> getUserPermissions(
    UserId userId,
  ) async {
    try {
      // 1. Get user's roles
      final rolesResult = await _userUserRoleRepository.getRolesForUser(userId);
      if (rolesResult.isLeft()) {
        return Left((rolesResult as Left).value);
      }
      final roles = (rolesResult as Right).value;

      if (roles.isEmpty) {
        return const Right({});
      }

      // 2. Get permissions for all roles
      final permissions = <Permission>{};
      for (final role in roles) {
        final permissionsResult = 
            await _userRolePermissionRepository.getPermissionsForRole(role.id);
        
        if (permissionsResult.isRight()) {
          final rolePermissions = (permissionsResult as Right).value;
          
          // 3. Convert to Permission enum
          for (final permEntity in rolePermissions) {
            final perm = Permission.fromCode(permEntity.code);
            if (perm != null && permEntity.isActive) {
              permissions.add(perm);
            }
          }
        }
      }

      return Right(permissions);
    } catch (e) {
      return Left(Exception('Error getting user permissions: $e'));
    }
  }

  Future<Either<Exception, bool>> userHasPermission({
    required UserId userId,
    required Permission permission,
  }) async {
    final result = await getUserPermissions(userId);
    
    return result.fold(
      (error) => Left(error),
      (permissions) => Right(permissions.contains(permission)),
    );
  }

  /// Check if user has any of the specified permissions
  Future<Either<Exception, bool>> userHasAnyPermission({
    required UserId userId,
    required List<Permission> permissions,
  }) async {
    final result = await getUserPermissions(userId);
    
    return result.fold(
      (error) => Left(error),
      (userPermissions) {
        final hasAny = permissions.any((p) => userPermissions.contains(p));
        return Right(hasAny);
      },
    );
  }

  /// Check if user has all of the specified permissions
  Future<Either<Exception, bool>> userHasAllPermissions({
    required UserId userId,
    required List<Permission> permissions,
  }) async {
    final result = await getUserPermissions(userId);
    
    return result.fold(
      (error) => Left(error),
      (userPermissions) {
        final hasAll = permissions.every((p) => userPermissions.contains(p));
        return Right(hasAll);
      },
    );
  }


  Future<Either<Exception, bool>> canUserPerformAction({
    required UserId userId,
    required Permission requiredPermission,
  }) async {
    return userHasPermission(
      userId: userId,
      permission: requiredPermission,
    );
  }
}
