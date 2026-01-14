import 'package:dartz/dartz.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';

/// Abstract repository for Department operations
/// 
/// NOTE: Department hierarchy is now managed through DepartmentInDepartmentRepository
/// This repository focuses on CRUD operations for departments themselves
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

  /// Get departments by name (search)
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByName(
    String name,
  );

  /// Get departments by hierarchy level
  /// Level 0 = root departments (companies)
  /// Level 1 = first level children (e.g., divisions)
  /// etc.
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByHierarchyLevel(
    int hierarchyLevel,
  );

  /// Create new department
  /// Note: Parent-child relationship must be created separately 
  /// in DepartmentInDepartmentRepository
  Future<Either<Exception, DepartmentEntity>> createDepartment({
    required String name,
    required DepartmentTypeId typeId,
    required int hierarchyLevel,
    required UserId createdBy,
  });

  /// Update department basic info (name, type)
  /// Note: To change parent, use DepartmentInDepartmentRepository.moveDepartment
  Future<Either<Exception, DepartmentEntity>> updateDepartment({
    required DepartmentId departmentId,
    String? name,
    DepartmentTypeId? typeId,
  });

  /// Update department hierarchy level (cached depth)
  /// This is typically called automatically by moveDepartment in DepartmentInDepartmentRepository
  /// Should NOT be called directly by application code
  Future<Either<Exception, DepartmentEntity>> updateDepartmentHierarchyLevel({
    required DepartmentId departmentId,
    required int newHierarchyLevel,
  });

  /// Deactivate department (soft delete)
  /// WARNING: This should also deactivate all relationships in 
  /// DepartmentInDepartmentRepository
  Future<Either<Exception, void>> deactivateDepartment({
    required DepartmentId departmentId,
    required DateTime deactivationDate,
  });

  /// Check if department exists
  Future<Either<Exception, bool>> departmentExists(DepartmentId departmentId);

  /// Check if department name exists (for validation)
  Future<Either<Exception, bool>> departmentNameExists(String name);

  /// Get department count by type
  /// Useful for analytics and validation
  Future<Either<Exception, int>> getDepartmentCountByType(
    DepartmentTypeId typeId,
  );

  /// Get department count by hierarchy level
  /// Useful for analytics
  Future<Either<Exception, int>> getDepartmentCountByHierarchyLevel(
    int hierarchyLevel,
  );

  /// Bulk create departments
  /// Useful for initial setup or imports
  Future<Either<Exception, List<DepartmentEntity>>> bulkCreateDepartments({
    required List<DepartmentEntity> departments,
    required UserId createdBy,
  });
}
