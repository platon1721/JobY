import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/features/auth/domain/repos/auth_repository.dart';

class SendPasswordResetEmailUseCase extends UseCase<void, SendPasswordResetEmailParams> {
  final AuthRepository repository;
  SendPasswordResetEmailUseCase(this.repository);

  @override
  Future<Either<Exception, void>> call(SendPasswordResetEmailParams params) {
    return repository.sendPasswordResetEmail(email: params.email);
  }
}

class SendPasswordResetEmailParams extends Equatable {
  final String email;
  const SendPasswordResetEmailParams({required this.email});

  @override
  List<Object?> get props => [email];
}
