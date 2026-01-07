

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/views/authentication/auth_view.dart';
import 'package:joby/views/authentication/register/register_view.dart';

/// JobY route configuration.
final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const AuthView();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterView();
        },
      )
    ]
);