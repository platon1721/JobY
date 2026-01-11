import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/mixins/auditable.dart';
import 'package:joby/core/utils/typedef/department_type_id.dart';
import 'package:joby/core/utils/typedef/department_type_in_type_id.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

class DepartmentTypeInType extends Equatable with Auditable{
  final DepartmentTypeInTypeId id;
  final DepartmentTypeId parentTypeId;
  final DepartmentTypeId childTypeId;

  const DepartmentTypeInType({
    required this.id,
    required this.parentTypeId,
    required this.childTypeId,
  });
  @override
  List<Object?> get props => [
    id,
    parentTypeId,
    childTypeId,
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