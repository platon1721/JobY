import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = UserStateInitial;
  const factory UserState.loading() = UserStateLoading;
  const factory UserState.loaded(UserEntity user) = UserStateLoaded;
  const factory UserState.success(String message) = UserStateSuccess;
  const factory UserState.error(String message) = UserStateError;
}