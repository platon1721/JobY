import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';
import 'package:joby/features/users/domain/repos/user_repository.dart';

/// Use case for getting all users in a specific department
class GetUsersByDepartmentUseCase extends UseCase<List<UserEntity>, GetUsersByDepartmentParams> {
  final UserRepository repository;

  GetUsersByDepartmentUseCase(this.repository);

  @override
  Future<Either<Exception, List<UserEntity>>> call(GetUsersByDepartmentParams params) {
    return repository.getUsersByDepartment(params.departmentId);
  }
}

/// Parameters for GetUsersByDepartmentUseCase
class GetUsersByDepartmentParams extends Equatable {
  final DepartmentId departmentId;

  const GetUsersByDepartmentParams({required this.departmentId});

  @override
  List<Object?> get props => [departmentId];
}
