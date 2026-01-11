import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class UserEntity extends Equatable with Auditable{
  final UserId userId;
  final String firstName;
  final String surName;
  final String email;
  final String? phoneNumber;

  const UserEntity({
    required this.userId,
    required this.firstName,
    required this.surName,
    required this.email,
    this.phoneNumber,
  });

  @override
  // TODO: implement activeTill
  DateTime? get activeTill => throw UnimplementedError();

  @override
  // TODO: implement createdAt
  DateTime get createdAt => throw UnimplementedError();

  @override
  // TODO: implement createdBy
  UserId get createdBy => throw UnimplementedError();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}