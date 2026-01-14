import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/auth/presentation/views/login_view.dart';
import 'package:joby/views/main/main_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainView(),
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = authState is AuthStateAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // Kui ei ole sisse logitud ja ei ole login lehel, suuna login lehele
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // Kui on sisse logitud ja on login lehel, suuna home lehele
      if (isAuthenticated && isLoggingIn) {
        return '/home';
      }

      // Muul juhul jää praegusel lehel
      return null;
    },
  );
});