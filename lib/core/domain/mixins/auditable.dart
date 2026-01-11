import 'package:joby/core/utils/typedef/user_id.dart';

mixin Auditable {
  UserId get createdBy;
  DateTime get createdAt;
  DateTime? get activeTill;
}