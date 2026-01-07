import 'package:joby/state/auth/models/auth_result.dart';
import 'package:joby/state/auth/providers/authentication_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_logged_in_provider.g.dart';

@riverpod
bool isLoggedIn(Ref ref) {
  final ahtProvider = ref.watch(authenticationProvider);
  return ahtProvider.result == AuthResult.success;
}