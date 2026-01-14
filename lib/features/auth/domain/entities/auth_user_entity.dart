import 'package:equatable/equatable.dart';

/// Auth user entity representing authenticated user from Firebase Auth
/// 
/// This is different from UserEntity which contains more detailed
/// user information stored in Firestore.
class AuthUserEntity extends Equatable {
  /// Firebase Auth UID
  final String uid;
  
  /// User's email address
  final String email;
  
  /// Display name (optional)
  final String? displayName;
  
  /// Photo URL (optional)
  final String? photoURL;
  
  /// Whether email is verified
  final bool emailVerified;
  
  /// Account creation timestamp
  final DateTime? createdAt;

  const AuthUserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.emailVerified,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoURL,
        emailVerified,
        createdAt,
      ];

  @override
  String toString() => 'AuthUserEntity(uid: $uid, email: $email)';

  /// Copy with new values
  AuthUserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    DateTime? createdAt,
  }) {
    return AuthUserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
