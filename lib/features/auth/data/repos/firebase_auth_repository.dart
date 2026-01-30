import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joby/core/errors/exceptions.dart';
import 'package:joby/features/auth/data/models/auth_user_model.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';
import 'package:joby/features/auth/domain/repos/auth_repository.dart';

/// Firebase implementation of AuthRepository
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _googleSignInInitialized = false;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  /// Initialize Google Sign-In
  Future<void> _initializeGoogleSignIn() async {
    if (_googleSignInInitialized) return;

    await _googleSignIn.initialize();
    _googleSignInInitialized = true;
  }

  @override
  Future<Either<Exception, AuthUserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return const Right(null);
      }

      final authUser = AuthUserModel.fromFirebaseUser(user);
      return Right(authUser);
    } on FirebaseAuthException catch (e) {
      return Left(ServerException('Firebase Auth error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error: $e'));
    }
  }

  @override
  Stream<AuthUserEntity?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUserModel.fromFirebaseUser(user);
    });
  }

  @override
  Future<Either<Exception, AuthUserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(ServerException('Login failed: No user returned'));
      }

      final authUser = AuthUserModel.fromFirebaseUser(userCredential.user!);
      return Right(authUser);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerException('Unexpected error during login: $e'));
    }
  }

  @override
  Future<Either<Exception, AuthUserEntity>> loginWithGoogle() async {
    try {
      await _initializeGoogleSignIn();

      GoogleSignInAccount? googleUser =
      await _googleSignIn.attemptLightweightAuthentication();

      if (googleUser == null) {
        if (_googleSignIn.supportsAuthenticate()) {
          googleUser = await _googleSignIn.authenticate();
        } else {
          return Left(ValidationException('Google Sign-In not supported on this platform'));
        }
      }
      if (googleUser == null) {
        return Left(ValidationException('Google sign-in aborted by user'));
      }


      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        return Left(ServerException('Failed to get ID token from Google'));
      }


      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return Left(ServerException('Google login failed: No user returned'));
      }

      final authUser = AuthUserModel.fromFirebaseUser(userCredential.user!);
      return Right(authUser);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerException('Google sign-in error: $e'));
    }
  }

  @override
  Future<Either<Exception, AuthUserEntity>> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(ServerException('Registration failed: No user returned'));
      }

      if (displayName != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload();
      }

      final updatedUser = _firebaseAuth.currentUser!;
      final authUser = AuthUserModel.fromFirebaseUser(updatedUser);
      return Right(authUser);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerException('Unexpected error during registration: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      try {
        await _initializeGoogleSignIn();
        await _googleSignIn.disconnect();
      } catch (_) {
      }

      await _firebaseAuth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerException('Logout error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error during logout: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerException('Unexpected error sending reset email: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return Left(ValidationException('No user is currently signed in'));
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerException('Profile update error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error updating profile: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return Left(ValidationException('No user is currently signed in'));
      }

      await user.delete();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return Left(
          ValidationException('Please re-authenticate before deleting account'),
        );
      }
      return Left(ServerException('Account deletion error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error deleting account: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return Left(ValidationException('No user is currently signed in'));
      }

      await user.reload();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerException('Reload error: ${e.message}'));
    } catch (e) {
      return Left(ServerException('Unexpected error reloading user: $e'));
    }
  }

  /// Handle Firebase Auth exceptions and convert to app exceptions
  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return ValidationException('No user found with this email');
      case 'wrong-password':
        return ValidationException('Wrong password');
      case 'invalid-email':
        return ValidationException('Invalid email address');
      case 'user-disabled':
        return ValidationException('This account has been disabled');
      case 'email-already-in-use':
        return ValidationException('Email already in use');
      case 'weak-password':
        return ValidationException('Password is too weak');
      case 'operation-not-allowed':
        return ValidationException('Operation not allowed');
      case 'too-many-requests':
        return ValidationException('Too many requests. Try again later');
      case 'network-request-failed':
        return ServerException('Network error. Check your connection');
      case 'account-exists-with-different-credential':
        return ValidationException(
          'An account already exists with the same email but different sign-in credentials',
        );
      default:
        return ServerException('Authentication error: ${e.message}');
    }
  }
}