import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/enums/permission.dart';
import 'package:joby/core/domain/services/permission_checker_service.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';
class CheckUserPermissionUseCase extends UseCase<bool, CheckUserPermissionParams> {
  final PermissionCheckerService permissionChecker;

  CheckUserPermissionUseCase(this.permissionChecker);

  @override
  Future<Either<Exception, bool>> call(CheckUserPermissionParams params) {
    return permissionChecker.userHasPermission(
      userId: params.userId,
      permission: params.permission,
    );
  }
}

class CheckUserPermissionParams extends Equatable {
  final UserId userId;
  final Permission permission;

  const CheckUserPermissionParams({
    required this.userId,
    required this.permission,
  });

  @override
  List<Object?> get props => [userId, permission];
}
