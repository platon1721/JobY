import 'package:dartz/dartz.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';

abstract class DepartmentRepository {
  /// Get department by ID
  Future<Either<Exception, DepartmentEntity>> getDepartmentById(
    DepartmentId departmentId,
  );

  /// Get all active departments
  Future<Either<Exception, List<DepartmentEntity>>> getAllDepartments();

  /// Get departments by type
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByType(
    DepartmentTypeId typeId,
  );

  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByName(
    String name,
  );

  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByHierarchyLevel(
    int hierarchyLevel,
  );

  Future<Either<Exception, DepartmentEntity>> createDepartment({
    required String name,
    required DepartmentTypeId typeId,
    required int hierarchyLevel,
    required UserId createdBy,
  });


  Future<Either<Exception, DepartmentEntity>> updateDepartment({
    required DepartmentId departmentId,
    String? name,
    DepartmentTypeId? typeId,
  });

  Future<Either<Exception, DepartmentEntity>> updateDepartmentHierarchyLevel({
    required DepartmentId departmentId,
    required int newHierarchyLevel,
  });


  Future<Either<Exception, void>> deactivateDepartment({
    required DepartmentId departmentId,
    required DateTime deactivationDate,
  });

  Future<Either<Exception, bool>> departmentExists(DepartmentId departmentId);

  Future<Either<Exception, bool>> departmentNameExists(String name);

  Future<Either<Exception, int>> getDepartmentCountByType(
    DepartmentTypeId typeId,
  );

  Future<Either<Exception, int>> getDepartmentCountByHierarchyLevel(
    int hierarchyLevel,
  );

  Future<Either<Exception, List<DepartmentEntity>>> bulkCreateDepartments({
    required List<DepartmentEntity> departments,
    required UserId createdBy,
  });
}
