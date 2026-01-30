import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoURL,
    required super.emailVerified,
    super.createdAt,
  });

  factory AuthUserModel.fromFirebaseUser(firebase_auth.User user) {
    return AuthUserModel(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
    );
  }

  /// Create AuthUserModel from Entity
  factory AuthUserModel.fromEntity(AuthUserEntity entity) {
    return AuthUserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      emailVerified: entity.emailVerified,
      createdAt: entity.createdAt,
    );
  }

  @override
  AuthUserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    DateTime? createdAt,
  }) {
    return AuthUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
