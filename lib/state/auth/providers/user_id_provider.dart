import 'package:joby/core/utils/typedef/user_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'authentication_provider.dart';


part 'user_id_provider.g.dart';

@riverpod
UserId? userId(Ref ref) {
  return ref.watch(authenticationProvider).userId;
}