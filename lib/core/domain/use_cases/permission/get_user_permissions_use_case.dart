import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/enums/permission.dart';
import 'package:joby/core/domain/services/permission_checker_service.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Use case for getting all permissions for a user
/// 
/// Returns a Set of all permissions aggregated from all of the user's roles.
/// Useful for displaying user capabilities or debugging permission issues.
class GetUserPermissionsUseCase extends UseCase<Set<Permission>, GetUserPermissionsParams> {
  final PermissionCheckerService permissionChecker;

  GetUserPermissionsUseCase(this.permissionChecker);

  @override
  Future<Either<Exception, Set<Permission>>> call(GetUserPermissionsParams params) {
    return permissionChecker.getUserPermissions(params.userId);
  }
}

/// Parameters for GetUserPermissionsUseCase
class GetUserPermissionsParams extends Equatable {
  final UserId userId;

  const GetUserPermissionsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
