import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/shared/department_user_entity.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/core/utils/typedef/department_user_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/core/utils/typedef/user_role_id.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';

/// Repository for DepartmentUser (user membership in departments)
abstract class DepartmentUserRepository {
  Future<Either<Exception, DepartmentUserEntity>> getDepartmentUserById(DepartmentUserId id);
  Future<Either<Exception, List<DepartmentUserEntity>>> getAllDepartmentUsers();
  Future<Either<Exception, List<UserEntity>>> getUsersInDepartment(DepartmentId departmentId);
  Future<Either<Exception, List<DepartmentUserEntity>>> getDepartmentsForUser(UserId userId);
  
  Future<Either<Exception, DepartmentUserEntity>> assignUserToDepartment({
    required DepartmentId departmentId,
    required UserId userId,
    required UserRoleId roleId,
    required UserId createdBy,
  });
  
  Future<Either<Exception, void>> removeUserFromDepartment({
    required DepartmentId departmentId,
    required UserId userId,
  });
  
  Future<Either<Exception, bool>> userIsInDepartment({
    required DepartmentId departmentId,
    required UserId userId,
  });
}
