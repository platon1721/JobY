import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';
import 'package:joby/features/departments/domain/repos/department_repository.dart';

class GetAllDepartmentsUseCase extends UseCaseNoParams<List<DepartmentEntity>> {
  final DepartmentRepository repository;
  GetAllDepartmentsUseCase(this.repository);

  @override
  Future<Either<Exception, List<DepartmentEntity>>> call() {
    return repository.getAllDepartments();
  }
}
