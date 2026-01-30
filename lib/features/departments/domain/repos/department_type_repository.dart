import 'package:dartz/dartz.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/departments/domain/entities/department_type_entity.dart';

abstract class DepartmentTypeRepository {
  Future<Either<Exception, DepartmentTypeEntity>> getDepartmentTypeById(
    DepartmentTypeId typeId,
  );
  Future<Either<Exception, List<DepartmentTypeEntity>>> getAllDepartmentTypes();
  Future<Either<Exception, List<DepartmentTypeEntity>>> getDepartmentTypesByName(
    String name,
  );
  Future<Either<Exception, DepartmentTypeEntity>> createDepartmentType({
    required String name,
    String? description,
    required UserId createdBy,
  });

  Future<Either<Exception, DepartmentTypeEntity>> updateDepartmentType({
    required DepartmentTypeId typeId,
    String? name,
    String? description,
  });

  Future<Either<Exception, void>> deactivateDepartmentType({
    required DepartmentTypeId typeId,
    required DateTime deactivationDate,
  });

  Future<Either<Exception, bool>> departmentTypeExists(
    DepartmentTypeId typeId,
  );

  Future<Either<Exception, bool>> departmentTypeNameExists(String name);

  Future<Either<Exception, int>> getDepartmentCountForType(
    DepartmentTypeId typeId,
  );
}
