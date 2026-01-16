import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/core/utils/validators/validators.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/auth/presentation/widgets/divider_with_margins.dart';
import 'package:joby/features/auth/presentation/widgets/gradient_background.dart';
import 'package:joby/theme/app_button_styles.dart';
import 'package:joby/theme/app_colors.dart';
import 'package:joby/theme/app_input_decorations.dart';
import 'package:joby/theme/app_strings.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).loginWithEmailPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (user) {
          // Navigate to home screen
          context.go('/home');
        },
        error: (message) {
          // Show error dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
        orElse: () {},
      );
    });

    return GradientBackground(child:
    Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 90,
          leading: BackButton(color: Colors.white),
          title: Image.asset(
            'assets/images/jobY.png',
            height: 90,
            fit: BoxFit.contain,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const SizedBox(height: 40),
                    OffsetText(
                      text: 'Login to Job.Y',
                      duration: const Duration(seconds: 4),
                      type: AnimationType.word,
                      slideType: SlideAnimationType.leftRight,
                      textStyle: (GoogleFonts.pacifico(
                          fontWeight: FontWeight.w500,
                          fontSize: 50,
                          color: Colors.white
                      )),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: AppInputDecorations.authField(label: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: AppInputDecorations.authField(
                        label: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      style: AppButtonStyles.primaryPillButtonStyle(),
                      onPressed: _attemptLogin,
                      child: const Text("Login"),
                    )
                  ]
              ),
            ),
          ),
        ))
    );
  }
}
