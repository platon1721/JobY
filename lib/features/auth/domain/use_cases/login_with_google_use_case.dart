import 'package:dartz/dartz.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';
import 'package:joby/features/auth/domain/repos/auth_repository.dart';

class LoginWithGoogleUseCase extends UseCaseNoParams<AuthUserEntity> {
  final AuthRepository repository;
  LoginWithGoogleUseCase(this.repository);

  @override
  Future<Either<Exception, AuthUserEntity>> call() {
    return repository.loginWithGoogle();
  }
}