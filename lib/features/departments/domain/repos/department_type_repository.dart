import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/department_type_entity.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Abstract repository for DepartmentType operations
abstract class DepartmentTypeRepository {
  /// Get department type by ID
  Future<Either<Exception, DepartmentTypeEntity>> getDepartmentTypeById(
    DepartmentTypeId typeId,
  );

  /// Get all active department types
  Future<Either<Exception, List<DepartmentTypeEntity>>> getAllDepartmentTypes();

  /// Get department types by name (search)
  Future<Either<Exception, List<DepartmentTypeEntity>>> getDepartmentTypesByName(
    String name,
  );

  /// Create new department type
  Future<Either<Exception, DepartmentTypeEntity>> createDepartmentType({
    required String name,
    String? description,
    required UserId createdBy,
  });

  /// Update department type
  Future<Either<Exception, DepartmentTypeEntity>> updateDepartmentType({
    required DepartmentTypeId typeId,
    String? name,
    String? description,
  });

  /// Deactivate department type (soft delete)
  Future<Either<Exception, void>> deactivateDepartmentType({
    required DepartmentTypeId typeId,
    required DateTime deactivationDate,
  });

  /// Check if department type exists
  Future<Either<Exception, bool>> departmentTypeExists(
    DepartmentTypeId typeId,
  );

  /// Check if department type name exists (for validation)
  Future<Either<Exception, bool>> departmentTypeNameExists(String name);

  /// Get count of departments using this type
  Future<Either<Exception, int>> getDepartmentCountForType(
    DepartmentTypeId typeId,
  );
}
