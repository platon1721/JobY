import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/permission_entity.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';

/// Abstract repository for Permission operations
/// Handles CRUD operations for permissions only
/// Note: Permissions are mostly read-only as they're hardcoded in Permission enum
abstract class PermissionRepository {
  /// Get all permissions
  Future<Either<Exception, List<PermissionEntity>>> getAllPermissions();

  /// Get permission by ID
  Future<Either<Exception, PermissionEntity>> getPermissionById(
    PermissionId permissionId,
  );

  /// Get permission by code (e.g., "user.create")
  Future<Either<Exception, PermissionEntity>> getPermissionByCode(
    String code,
  );

  /// Get permissions by category (e.g., all "user.*" permissions)
  Future<Either<Exception, List<PermissionEntity>>> getPermissionsByCategory(
    String category,
  );

  /// Check if permission exists
  Future<Either<Exception, bool>> permissionExists(PermissionId permissionId);

  /// Check if permission code exists
  Future<Either<Exception, bool>> permissionCodeExists(String code);
}
