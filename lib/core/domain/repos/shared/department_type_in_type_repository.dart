import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/shared/department_type_in_type_entity.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/department_type_in_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/departments/domain/entities/department_type_entity.dart';

/// Repository for DepartmentTypeInType
abstract class DepartmentTypeInTypeRepository {
  /// Get relationship by ID
  Future<Either<Exception, DepartmentTypeInTypeEntity>> getRelationshipById(
    DepartmentTypeInTypeId id,
  );

  /// Get all type relationships
  Future<Either<Exception, List<DepartmentTypeInTypeEntity>>> getAllRelationships();

  /// Get allowed child types for a parent type
  Future<Either<Exception, List<DepartmentTypeEntity>>> getAllowedChildTypes(
    DepartmentTypeId parentTypeId,
  );

  /// Get allowed parent types for a child type
  Future<Either<Exception, List<DepartmentTypeEntity>>> getAllowedParentTypes(
    DepartmentTypeId childTypeId,
  );

  /// Check if parent type can have this child type
  Future<Either<Exception, bool>> canHaveChildType({
    required DepartmentTypeId parentTypeId,
    required DepartmentTypeId childTypeId,
  });

  /// Create type relationship (allow parent to have child)
  Future<Either<Exception, DepartmentTypeInTypeEntity>> createRelationship({
    required DepartmentTypeId parentTypeId,
    required DepartmentTypeId childTypeId,
    required UserId createdBy,
  });

  /// Remove type relationship
  Future<Either<Exception, void>> removeRelationship({
    required DepartmentTypeId parentTypeId,
    required DepartmentTypeId childTypeId,
  });
}
