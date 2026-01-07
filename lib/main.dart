import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/firebase_options.dart';
import 'package:joby/router/router.dart';
import 'package:joby/views/constants/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig:  router,
        title: AppStrings.appTitle,
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        )
    );
  }
}
