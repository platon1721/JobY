import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class DepartmentTypeEntity extends Equatable with Auditable{
  final DepartmentTypeId id;
  final String name;

  const DepartmentTypeEntity({
    required this.id,
    required this.name,
  });
  @override
  List<Object?> get props => [
    id,
    name,
  ];

  @override
  // TODO: implement activeTill
  DateTime? get activeTill => throw UnimplementedError();

  @override
  // TODO: implement createdAt
  DateTime get createdAt => throw UnimplementedError();

  @override
  // TODO: implement createdBy
  UserId get createdBy => throw UnimplementedError();

}