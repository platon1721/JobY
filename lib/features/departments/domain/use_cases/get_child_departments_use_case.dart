import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/entities/department_entity.dart';
import 'package:joby/core/domain/repos/department_in_department_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/department_id.dart';

class GetChildDepartmentsUseCase extends UseCase<List<DepartmentEntity>, GetChildDepartmentsParams> {
  final DepartmentInDepartmentRepository repository;
  GetChildDepartmentsUseCase(this.repository);

  @override
  Future<Either<Exception, List<DepartmentEntity>>> call(GetChildDepartmentsParams params) {
    return repository.getChildDepartments(params.parentId);
  }
}

class GetChildDepartmentsParams extends Equatable {
  final DepartmentId parentId;
  const GetChildDepartmentsParams({required this.parentId});

  @override
  List<Object?> get props => [parentId];
}
