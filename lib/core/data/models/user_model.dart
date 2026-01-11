import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/core/domain/entities/user_entity.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Model for User with Firebase support
class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.firstName,
    required super.surName,
    required super.email,
    super.phoneNumber,
    required super.createdAt,
    required super.createdBy,
    super.activeTill,
  });

  /// Create UserModel from Firebase DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      userId: doc.id,
      firstName: data['first_name'] as String,
      surName: data['sur_name'] as String,
      email: data['email'] as String,
      phoneNumber: data['phone_number'] as String?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] as UserId,
      activeTill: data['active_till'] != null
          ? (data['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      userId: id,
      firstName: map['first_name'] as String,
      surName: map['sur_name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phone_number'] as String?,
      createdAt: (map['created_at'] as Timestamp).toDate(),
      createdBy: map['created_by'] as UserId,
      activeTill: map['active_till'] != null
          ? (map['active_till'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'first_name': firstName,
      'sur_name': surName,
      'email': email,
      'phone_number': phoneNumber,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'active_till': activeTill != null ? Timestamp.fromDate(activeTill!) : null,
    };
  }

  /// Create UserModel from Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      firstName: entity.firstName,
      surName: entity.surName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      activeTill: entity.activeTill,
    );
  }

  /// Copy with new values
  @override
  UserModel copyWith({
    UserId? userId,
    String? firstName,
    String? surName,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    UserId? createdBy,
    DateTime? activeTill,
  }) {
    return UserModel(
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