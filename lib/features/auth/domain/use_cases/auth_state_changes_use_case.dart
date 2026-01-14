import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';
import 'package:joby/features/auth/domain/repos/auth_repository.dart';

/// Use case for listening to auth state changes
/// Returns a stream that emits when user logs in/out
class AuthStateChangesUseCase {
  final AuthRepository repository;
  AuthStateChangesUseCase(this.repository);

  Stream<AuthUserEntity?> call() {
    return repository.authStateChanges();
  }
}
