import 'package:equatable/equatable.dart';


class AuthUserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
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
