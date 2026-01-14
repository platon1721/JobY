import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:joby/core/domain/enums/permission.dart';
import 'package:joby/core/domain/services/permission_checker_service.dart';
import 'package:joby/core/domain/use_cases/common/use_case.dart';
import 'package:joby/core/utils/typedef/user_id.dart';

/// Use case for checking if a user has a specific permission
/// 
/// This is the primary permission checking use case that should be used
/// throughout the application to verify user access.
/// 
/// Example:
/// ```dart
/// final hasPermission = await checkPermission(
///   CheckUserPermissionParams(
///     userId: currentUserId,
///     permission: Permission.userCreate,
///   ),
/// );
/// 
/// hasPermission.fold(
///   (error) => showError(error),
///   (allowed) => allowed ? showCreateDialog() : showAccessDenied(),
/// );
/// ```
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

/// Parameters for CheckUserPermissionUseCase
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
