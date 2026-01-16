import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/auth/presentation/views/login_view.dart';
import 'package:joby/features/auth/presentation/views/register_view.dart';
import 'package:joby/features/auth/presentation/views/welcome_view.dart';
import 'package:joby/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:joby/features/dashboard/presentation/views/profile_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<AuthState>(const AuthState.initial());

  ref.listen(authControllerProvider, (_, next) {
    authNotifier.value = next;
  });

  return GoRouter(
    initialLocation: '/welcome',  // Muudetud: algab welcome view'st
    refreshListenable: authNotifier,
    routes: [
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const DashboardView(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileView(),
      ),
    ],
    redirect: (context, state) {
      final authState = authNotifier.value;
      final isAuthenticated = authState is AuthStateAuthenticated;
      final isRegistering = authState is AuthStateRegistering;
      final location = state.matchedLocation;

      if (isRegistering) {
        return null;
      }

      // Authenticated kasutaja suunatakse home'i
      if (isAuthenticated) {
        if (location == '/welcome' || location == '/login' || location == '/register') {
          return '/home';
        }
        return null;
      }

      // Mitte-authenticated kasutaja saab olla welcome, login või register lehel
      if (!isAuthenticated) {
        if (location != '/welcome' && location != '/login' && location != '/register') {
          return '/welcome';
        }
      }

      return null;
    },
  );
});