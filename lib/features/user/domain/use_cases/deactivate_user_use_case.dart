import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/repos/user_repository.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Use case for deactivating a user (soft delete)
class DeactivateUserUseCase extends UseCase<void, DeactivateUserParams> {
  final UserRepository repository;

  DeactivateUserUseCase(this.repository);

  @override
  Future<Either<Exception, void>> call(DeactivateUserParams params) {
    return repository.deactivateUser(
      userId: params.userId,
      deactivationDate: params.deactivationDate ?? DateTime.now(),
    );
  }
}

/// Parameters for DeactivateUserUseCase
class DeactivateUserParams extends Equatable {
  final UserId userId;
  final DateTime? deactivationDate;

  const DeactivateUserParams({
    required this.userId,
    this.deactivationDate,
  });

  @override
  List<Object?> get props => [userId, deactivationDate];
}
