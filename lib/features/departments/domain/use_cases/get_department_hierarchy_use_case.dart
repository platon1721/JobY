import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/repos/shared/department_in_department_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/department_id.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';

class GetDepartmentHierarchyUseCase extends UseCase<List<DepartmentEntity>, GetDepartmentHierarchyParams> {
  final DepartmentInDepartmentRepository repository;
  GetDepartmentHierarchyUseCase(this.repository);

  @override
  Future<Either<Exception, List<DepartmentEntity>>> call(GetDepartmentHierarchyParams params) {
    return repository.getAllDescendants(params.departmentId);
  }
}

class GetDepartmentHierarchyParams extends Equatable {
  final DepartmentId departmentId;
  const GetDepartmentHierarchyParams({required this.departmentId});

  @override
  List<Object?> get props => [departmentId];
}
