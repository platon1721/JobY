import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';
import 'package:joby/features/users/domain/repos/user_repository.dart';

/// Use case for getting all active users
class GetAllUsersUseCase extends UseCaseNoParams<List<UserEntity>> {
  final UserRepository repository;

  GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Exception, List<UserEntity>>> call() {
    return repository.getAllUsers();
  }
}
