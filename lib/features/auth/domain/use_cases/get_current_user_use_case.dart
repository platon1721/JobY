import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';
import 'package:joby/features/auth/domain/repos/auth_repository.dart';

class GetCurrentUserUseCase extends UseCaseNoParams<AuthUserEntity?> {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Exception, AuthUserEntity?>> call() {
    return repository.getCurrentUser();
  }
}
