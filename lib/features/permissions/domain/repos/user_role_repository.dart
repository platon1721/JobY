import 'package:dartz/dartz.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/features/permissions/domain/entities/user_role_entity.dart';

abstract class UserRoleRepository {
  /// Get role by ID
  Future<Either<Exception, UserRoleEntity>> getRoleById(UserRoleId roleId);

  /// Get all active roles
  Future<Either<Exception, List<UserRoleEntity>>> getAllRoles();

  /// Get roles by name (for search)
  Future<Either<Exception, List<UserRoleEntity>>> getRolesByName(String name);

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

  Future<Either<Exception, void>> deactivateRole({
    required UserRoleId roleId,
    required DateTime deactivationDate,
  });

  Future<Either<Exception, bool>> roleExists(UserRoleId roleId);

  Future<Either<Exception, bool>> roleNameExists(String name);
}
