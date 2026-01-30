
import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/auth/presentation/providers/auth_providers.dart';
import 'package:joby/features/users/domain/use_cases/create_user_use_case.dart';
import 'package:joby/features/users/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:joby/features/users/domain/use_cases/update_user_use_case.dart';
import 'package:joby/features/users/presentation/controllers/user_state.dart';
import 'package:joby/features/users/presentation/providers/user_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
class UserController extends _$UserController {
  @override
  UserState build() {
    return const UserState.initial();
  }

  Future<void> loadCurrentUser() async {
    state = const UserState.loading();

    try {
      final getUserByIdUseCase = ref.read(getUserByIdUseCaseProvider);
      final authState = ref.read(authControllerProvider);

      final userId = authState.maybeWhen(
        authenticated: (user) => user.uid,
        orElse: () => null,
      );

      if (userId == null) {
        state = const UserState.error('User not found');
        return;
      }

      final result = await getUserByIdUseCase(
        GetUserByIdParams(userId: userId),
      );

      result.fold(
            (error) => state = UserState.error(error.toString()),
            (user) => state = UserState.loaded(user),
      );
    } catch (e) {
      state = UserState.error('User error: $e');
    }
  }

  Future<void> updateUserProfile({
    required String? firstName,
    required String? surName,
    required String? email,
    required String? phoneNumber,
  }) async {
    state = const UserState.loading();

    try {
      final updateUserUseCase = ref.read(updateUserUseCaseProvider);

      final authState = ref.read(authControllerProvider);

      final userId = authState.maybeWhen(
        authenticated: (user) => user.uid,
        orElse: () => null,
      );

      if (userId == null) {
        state = const UserState.error('Kasutaja pole autentitud');
        return;
      }

      final result = await updateUserUseCase(
        UpdateUserParams(
          userId: userId,
          firstName: firstName,
          surName: surName,
          email: email,
          phoneNumber: phoneNumber,
        ),
      );

      result.fold(
            (error) => state = UserState.error(error.toString()),
            (updatedUser) {
          state = UserState.success('Profile is updated successfully');
          Future.delayed(const Duration(milliseconds: 500), () {
            state = UserState.loaded(updatedUser);
          });
        },
      );
    } catch (e) {
      state = UserState.error('Error: $e');
    }
  }

  Future<void> getUserById(String userId) async {
    state = const UserState.loading();

    try {
      final getUserByIdUseCase = ref.read(getUserByIdUseCaseProvider);

      final result = await getUserByIdUseCase(
        GetUserByIdParams(userId: userId),
      );

      result.fold(
            (error) => state = UserState.error(error.toString()),
            (user) => state = UserState.loaded(user),
      );
    } catch (e) {
      state = UserState.error('Error: $e');
    }
  }

  Future<bool> createUserAfterRegistration({
    required UserId id,
    required String firstName,
    required String surName,
    required String email,
    String? phoneNumber,
    required String createdBy,
  }) async {
    state = const UserState.loading();

    try {
      final createUserUseCase = ref.read(createUserUseCaseProvider);

      final result = await createUserUseCase(
        CreateUserParams(
          userId: id,
          firstName: firstName,
          surName: surName,
          email: email,
          phoneNumber: phoneNumber,
          createdBy: createdBy,
        ),
      );

      return result.fold(
            (error) {
          state = UserState.error(error.toString());
          return false;
        },
            (user) {
          state = UserState.loaded(user);
          return true;
        },
      );
    } catch (e) {
      state = UserState.error('Error: $e');
      return false;
    }
  }

  void clearError() {
    if (state is UserStateError) {
      state = const UserState.initial();
    }
  }
}