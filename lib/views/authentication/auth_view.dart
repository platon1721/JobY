import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/state/auth/providers/is_logged_in_provider.dart';
import 'package:joby/state/is_loading/providers/is_loading_provider.dart';
import 'package:joby/views/authentication/login/login_view.dart';
import 'package:joby/views/components/loading/loading_screen.dart';
import 'package:joby/views/main/main_view.dart';


class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {

      ref.listen(isLoadingProvider, (_, isLoading) {
        if (isLoading) {
          LoadingScreen.instance().show(context: context);
        } else {
          LoadingScreen.instance().hide();
        }
      });


      final isLoggedIn = ref.watch(isLoggedInProvider);
      if (isLoggedIn) {
        return const MainView();
      } else {
        return const LoginView();
      }
    });
  }
}
