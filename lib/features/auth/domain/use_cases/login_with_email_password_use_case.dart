import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';
import 'package:joby/features/auth/domain/repos/auth_repository.dart';

/// Use case for logging in with email and password
class LoginWithEmailPasswordUseCase
    extends UseCase<AuthUserEntity, LoginWithEmailPasswordParams> {
  final AuthRepository repository;

  LoginWithEmailPasswordUseCase(this.repository);

  @override
  Future<Either<Exception, AuthUserEntity>> call(
    LoginWithEmailPasswordParams params,
  ) {
    return repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for login use case
class LoginWithEmailPasswordParams extends Equatable {
  final String email;
  final String password;

  const LoginWithEmailPasswordParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
