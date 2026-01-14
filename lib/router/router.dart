import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  GoRouter(
    redirect: (context, state) {
      final isAuthenticated = authState is AuthStateAuthenticated;

      if (!isAuthenticated && state.matchedLocation == 'home') {
        return '/login';
      }

      if (isAuthenticated && state.matchedLocation == '/login') {
        return '/home';
      }

      return null;
    }
  );

});