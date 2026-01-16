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
import 'package:joby/features/departments/presentation/views/department_detail_view.dart';
import 'package:joby/features/departments/presentation/views/department_hierarchy_view.dart';
import 'package:joby/features/departments/presentation/views/department_types_view.dart';
import 'package:joby/features/departments/presentation/views/departments_views.dart';
import 'package:joby/features/permissions/presentation/views/roles_view.dart';
import 'package:joby/features/permissions/presentation/views/role_detail_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<AuthState>(const AuthState.initial());

  ref.listen(authControllerProvider, (_, next) {
    authNotifier.value = next;
  });

  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: authNotifier,
    routes: [
      // Auth routes
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

      // Main app routes
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

      // Department routes
      GoRoute(
        path: '/departments',
        name: 'departments',
        builder: (context, state) => const DepartmentsView(),
      ),
      GoRoute(
        path: '/departments/:id',
        name: 'department-detail',
        builder: (context, state) {
          final departmentId = state.pathParameters['id']!;
          return DepartmentDetailView(departmentId: departmentId);
        },
      ),

      // Department Hierarchy route
      GoRoute(
        path: '/department-hierarchy',
        name: 'department-hierarchy',
        builder: (context, state) => const DepartmentHierarchyView(),
      ),

      // Department Types route
      GoRoute(
        path: '/department-types',
        name: 'department-types',
        builder: (context, state) => const DepartmentTypesView(),
      ),

      // Role/Permission routes
      GoRoute(
        path: '/roles',
        name: 'roles',
        builder: (context, state) => const RolesView(),
      ),
      GoRoute(
        path: '/roles/:id',
        name: 'role-detail',
        builder: (context, state) {
          final roleId = state.pathParameters['id']!;
          return RoleDetailView(roleId: roleId);
        },
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
