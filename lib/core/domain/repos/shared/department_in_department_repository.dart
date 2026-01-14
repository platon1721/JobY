import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/department_entity.dart';
import 'package:joby/core/domain/entities/department_in_department_entity.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_in_department_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Abstract repository for DepartmentInDepartment operations
/// Junction table managing hierarchical relationships between departments
/// This replaces the old parentId approach in Department entity
abstract class DepartmentInDepartmentRepository {
  /// Get relationship by ID
  Future<Either<Exception, DepartmentInDepartmentEntity>> getRelationshipById(
    DepartmentInDepartmentId id,
  );

  /// Get all active relationships
  Future<Either<Exception, List<DepartmentInDepartmentEntity>>>
      getAllRelationships();

  /// Get parent department entity for a child
  Future<Either<Exception, DepartmentEntity?>> getParentDepartment(
    DepartmentId childId,
  );

  /// Get all child department entities for a parent
  Future<Either<Exception, List<DepartmentEntity>>> getChildDepartments(
    DepartmentId parentId,
  );

  /// Get all parent-child relationships for a specific parent
  Future<Either<Exception, List<DepartmentInDepartmentEntity>>>
      getRelationshipsForParent(
    DepartmentId parentId,
  );

  /// Get all parent-child relationships for a specific child
  Future<Either<Exception, List<DepartmentInDepartmentEntity>>>
      getRelationshipsForChild(
    DepartmentId childId,
  );

  /// Get all descendants (recursive) of a department as flat list
  /// Returns all children, grandchildren, etc.
  Future<Either<Exception, List<DepartmentEntity>>> getAllDescendants(
    DepartmentId parentId,
  );

  /// Get ancestry path from root to specific department
  /// Returns list of departments from root to target (inclusive)
  /// Example: [Company, Division, Department, Team]
  Future<Either<Exception, List<DepartmentEntity>>> getAncestryPath(
    DepartmentId departmentId,
  );

  /// Create new parent-child relationship
  /// This establishes department hierarchy
  Future<Either<Exception, DepartmentInDepartmentEntity>>
      createRelationship({
    required DepartmentId parentId,
    required DepartmentId childId,
    required UserId createdBy,
  });

  /// Move department to new parent
  /// Removes old parent relationship and creates new one
  Future<Either<Exception, void>> moveDepartment({
    required DepartmentId departmentId,
    required DepartmentId newParentId,
    required UserId movedBy,
  });

  /// Remove parent-child relationship (soft delete by setting activeTill)
  Future<Either<Exception, void>> removeRelationship({
    required DepartmentId parentId,
    required DepartmentId childId,
  });

  /// Check if department has any children
  Future<Either<Exception, bool>> hasChildren(DepartmentId departmentId);

  /// Check if department has a parent
  Future<Either<Exception, bool>> hasParent(DepartmentId departmentId);

  /// Check if creating this relationship would create a circular reference
  /// Example: A is parent of B, B is parent of C, trying to make C parent of A
  Future<Either<Exception, bool>> wouldCreateCircularReference({
    required DepartmentId parentId,
    required DepartmentId childId,
  });

  /// Validate that a department can be moved to a new parent
  /// Checks for circular references and type compatibility
  Future<Either<Exception, bool>> canMoveDepartment({
    required DepartmentId departmentId,
    required DepartmentId newParentId,
  });

  /// Get root departments (departments with no parent)
  Future<Either<Exception, List<DepartmentEntity>>> getRootDepartments();

  /// Get depth of department in hierarchy (0 = root)
  Future<Either<Exception, int>> getDepartmentDepth(DepartmentId departmentId);

  /// Deactivate all relationships for a department (when department is deleted)
  /// Includes both parent and child relationships
  Future<Either<Exception, void>> deactivateAllRelationships({
    required DepartmentId departmentId,
    required DateTime deactivationDate,
  });
}
