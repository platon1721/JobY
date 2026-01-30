import 'package:dartz/dartz.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Exception, AuthUserEntity?>> getCurrentUser();
  Stream<AuthUserEntity?> authStateChanges();
  Future<Either<Exception, AuthUserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Exception, AuthUserEntity>> loginWithGoogle();
  Future<Either<Exception, AuthUserEntity>> register({
    required String email,
    required String password,
    String? displayName,
  });
  Future<Either<Exception, void>> logout();

  Future<Either<Exception, void>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Exception, void>> updateProfile({
    String? displayName,
    String? photoURL,
  });

  Future<Either<Exception, void>> deleteAccount();

  Future<Either<Exception, void>> reloadUser();
}