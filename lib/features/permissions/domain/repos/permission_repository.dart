import 'package:dartz/dartz.dart';
import 'package:joby/core/utils/typedef/permission_id.dart';
import 'package:joby/features/permissions/domain/entities/permission_entity.dart';


abstract class PermissionRepository {
  Future<Either<Exception, List<PermissionEntity>>> getAllPermissions();

  Future<Either<Exception, PermissionEntity>> getPermissionById(
    PermissionId permissionId,
  );

  Future<Either<Exception, PermissionEntity>> getPermissionByCode(
    String code,
  );

  Future<Either<Exception, List<PermissionEntity>>> getPermissionsByCategory(
    String category,
  );

  Future<Either<Exception, bool>> permissionExists(PermissionId permissionId);

  Future<Either<Exception, bool>> permissionCodeExists(String code);
}
