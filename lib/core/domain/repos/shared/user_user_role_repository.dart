import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/shared/user_user_role_entity.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/core/utils/typedef/user_user_role_id.dart';
import 'package:joby/features/permissions/domain/entities/user_role_entity.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';

/// Abstract repository for UserUserRole operations
/// Junction table: manages relationships between users and roles
abstract class UserUserRoleRepository {
  /// Get all user-role assignments
  Future<Either<Exception, List<UserUserRoleEntity>>> getAllUserRoles();

  /// Get user-role assignment by ID
  Future<Either<Exception, UserUserRoleEntity>> getUserRoleById(
    UserUserRoleId id,
  );

  /// Get all roles for a specific user
  Future<Either<Exception, List<UserRoleEntity>>> getRolesForUser(
    UserId userId,
  );

  /// Get all users that have a specific role
  Future<Either<Exception, List<UserEntity>>> getUsersWithRole(
    UserRoleId roleId,
  );

  /// Assign role to user
  Future<Either<Exception, UserUserRoleEntity>> assignRoleToUser({
    required UserId userId,
    required UserRoleId roleId,
    required UserId createdBy,
  });

  /// Remove role from user (set activeTill)
  Future<Either<Exception, void>> removeRoleFromUser({
    required UserId userId,
    required UserRoleId roleId,
  });

  /// Check if user has specific role
  Future<Either<Exception, bool>> userHasRole({
    required UserId userId,
    required UserRoleId roleId,
  });

  /// Bulk assign roles to user
  Future<Either<Exception, List<UserUserRoleEntity>>> assignRolesToUser({
    required UserId userId,
    required List<UserRoleId> roleIds,
    required UserId createdBy,
  });

  /// Remove all roles from user
  Future<Either<Exception, void>> removeAllRolesFromUser({
    required UserId userId,
    required DateTime deactivationDate,
  });
}
