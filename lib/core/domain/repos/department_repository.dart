import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/department_entity.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Abstract repository for Department operations
/// Departments have hierarchical structure (tree)
abstract class DepartmentRepository {
  /// Get department by ID
  Future<Either<Exception, DepartmentEntity>> getDepartmentById(
      DepartmentId departmentId,
      );

  /// Get all departments
  Future<Either<Exception, List<DepartmentEntity>>> getAllDepartments();

  /// Get root department (company level, where parentId is null)
  Future<Either<Exception, DepartmentEntity>> getRootDepartment();

  /// Get child departments of a parent
  Future<Either<Exception, List<DepartmentEntity>>> getChildDepartments(
      DepartmentId parentId,
      );

  /// Get departments by type
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentsByType(
      DepartmentTypeId typeId,
      );

  /// Get all departments in a tree (recursive)
  /// Returns department and all its children as flat list
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentTree(
      DepartmentId rootId,
      );

  /// Get department hierarchy path (from root to department)
  /// Example: Company -> Division -> Department -> Team
  Future<Either<Exception, List<DepartmentEntity>>> getDepartmentPath(
      DepartmentId departmentId,
      );

  /// Create new department
  Future<Either<Exception, DepartmentEntity>> createDepartment({
    required String name,
    required DepartmentTypeId typeId,
    required DepartmentId? parentId,
    required UserId createdBy,
  });

  /// Update department
  Future<Either<Exception, DepartmentEntity>> updateDepartment({
    required DepartmentId departmentId,
    String? name,
    DepartmentTypeId? typeId,
  });

  /// Move department to new parent
  /// This also updates the level of all children
  Future<Either<Exception, void>> moveDepartment({
    required DepartmentId departmentId,
    required DepartmentId newParentId,
  });

  /// Deactivate department (soft delete)
  /// Also deactivates all child departments
  Future<Either<Exception, void>> deactivateDepartment({
    required DepartmentId departmentId,
    required DateTime deactivationDate,
  });

  /// Check if department can have this type as child
  /// Based on department_type_in_type rules
  Future<Either<Exception, bool>> canHaveChildType({
    required DepartmentId parentId,
    required DepartmentTypeId childTypeId,
  });

  /// Validate department hierarchy
  /// Checks for circular references, depth limits, etc.
  Future<Either<Exception, bool>> validateHierarchy(
      DepartmentId departmentId,
      );
}