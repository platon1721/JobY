import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';

part 'auth_state.freezed.dart';

/// Auth state representing different authentication states
@freezed
class AuthState with _$AuthState {
  /// Initial state - checking authentication
  const factory AuthState.initial() = AuthStateInitial;

  /// User is authenticated
  const factory AuthState.authenticated(AuthUserEntity user) = AuthStateAuthenticated;

  /// User is not authenticated
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;

  /// Loading state (login, register, logout in progress)
  const factory AuthState.loading() = AuthStateLoading;

  /// Error state
  const factory AuthState.error(String message) = AuthStateError;
}
