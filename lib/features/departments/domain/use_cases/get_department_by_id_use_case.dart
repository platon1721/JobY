import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/domain/repos/department_repository.dart';

class GetDepartmentByIdUseCase extends UseCase<DepartmentEntity, GetDepartmentByIdParams> {
  final DepartmentRepository repository;
  GetDepartmentByIdUseCase(this.repository);

  @override
  Future<Either<Exception, DepartmentEntity>> call(GetDepartmentByIdParams params) {
    return repository.getDepartmentById(params.departmentId);
  }
}

class GetDepartmentByIdParams extends Equatable {
  final DepartmentId departmentId;
  const GetDepartmentByIdParams({required this.departmentId});

  @override
  List<Object?> get props => [departmentId];
}
