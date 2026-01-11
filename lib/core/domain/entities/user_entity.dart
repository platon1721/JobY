import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class UserEntity extends Equatable with Auditable {
  final UserId userId;
  final String firstName;
  final String surName;
  final String email;
  final String? phoneNumber;

  @override
  final DateTime createdAt;

  @override
  final UserId createdBy;

  @override
  final DateTime? activeTill;

  const UserEntity({
    required this.userId,
    required this.firstName,
    required this.surName,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
    required this.createdBy,
    this.activeTill,
  });

  /// Get full name of the user
  String get fullName => '$firstName $surName';

  /// Check if user is active
  bool get isActive => activeTill == null || activeTill!.isAfter(DateTime.now());

  @override
  List<Object?> get props => [
    userId,
    firstName,
    surName,
    email,
    phoneNumber,
    createdAt,
    createdBy,
    activeTill,
  ];

  @override
  String toString() => 'UserEntity(id: $userId, name: $fullName, email: $email)';

  /// Create a copy with updated fields
  UserEntity copyWith({
    UserId? userId,
    String? firstName,
    String? surName,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      surName: surName ?? this.surName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      activeTill: activeTill ?? this.activeTill,
    );
  }
}