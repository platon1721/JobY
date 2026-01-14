import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/entities/department_entity.dart';
import 'package:joby/core/domain/repos/department_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';

class GetAllDepartmentsUseCase extends UseCaseNoParams<List<DepartmentEntity>> {
  final DepartmentRepository repository;
  GetAllDepartmentsUseCase(this.repository);

  @override
  Future<Either<Exception, List<DepartmentEntity>>> call() {
    return repository.getAllDepartments();
  }
}
