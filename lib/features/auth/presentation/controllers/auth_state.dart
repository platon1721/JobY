import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:joby/features/auth/domain/entities/auth_user_entity.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.authenticated(AuthUserEntity user) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.error(String message) = AuthStateError;
  const factory AuthState.registering(AuthUserEntity user) = AuthStateRegistering;
}
