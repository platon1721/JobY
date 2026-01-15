import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/auth/presentation/views/login_view.dart';
import 'package:joby/features/auth/presentation/views/register_view.dart';
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
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = authState is AuthStateAuthenticated;
      final location = state.matchedLocation;

      if (isAuthenticated) {
        if (location == '/login' || location == '/register') {
          return '/home'; // Suuna home lehele kui on juba sisse logitud
        }
        return null;
      }

      if (!isAuthenticated && location != '/register' && location != '/login') {
        return '/login';
      }
      return null;
       // Suuna login lehele kui pole sisse logitud
    },
  );
});
