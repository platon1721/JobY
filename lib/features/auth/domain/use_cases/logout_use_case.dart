import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/features/auth/domain/repos/auth_repository.dart';

class LogoutUseCase extends UseCaseNoParams<void> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<Either<Exception, void>> call() {
    return repository.logout();
  }
}
