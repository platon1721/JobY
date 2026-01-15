import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:joby/features/users/domain/entities/user_entity.dart';

part 'user_state.freezed.dart';

/// UserState - kujutab kasutaja haldamise erinevaid olekuid
@freezed
class UserState with _$UserState {
  /// Algne olek - midagi ei laadi
  const factory UserState.initial() = UserStateInitial;

  /// Andmeid laadib
  const factory UserState.loading() = UserStateLoading;

  /// Kasutaja andmed edukalt laetud
  const factory UserState.loaded(UserEntity user) = UserStateLoaded;

  /// Operatsioon õnnestus (profiili uuendamine jne)
  const factory UserState.success(String message) = UserStateSuccess;

  /// Viga tekkis
  const factory UserState.error(String message) = UserStateError;
}