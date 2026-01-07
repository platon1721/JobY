import 'package:joby/state/auth/providers/authentication_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_loading_provider.g.dart';



// TODO: add more providers here later
@riverpod
bool isLoading(Ref ref) {
  final authentication = ref.watch(authenticationProvider);
  return authentication.isLoading;
}