import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/core/utils/validators/validators.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/auth/presentation/widgets/divider_with_margins.dart';
import 'package:joby/features/auth/presentation/widgets/gradient_background.dart';
import 'package:joby/features/users/domain/use_cases/create_user_use_case.dart';
import 'package:joby/features/users/presentation/controllers/user_controller.dart';
import 'package:joby/features/users/presentation/providers/user_providers.dart';
import 'package:joby/state/auth/providers/authentication_provider.dart';
import 'package:joby/theme/app_button_styles.dart';
import 'package:joby/theme/app_colors.dart';
import 'package:joby/theme/app_input_decorations.dart';
import 'package:joby/theme/app_strings.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _surNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _surNameController.dispose();
    super.dispose();
  }

  Future<void> _attemptRegister() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        surName: _surNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (user) {
          if (mounted) {
            context.pop();
          }
        },
        error: (message) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        orElse: () {},
      );
    });


    return GradientBackground(
      child: Scaffold(
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
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const SizedBox(height: 40),
                  OffsetText(
                    text: 'Register to Job.Y',
                    duration: const Duration(seconds: 4),
                    type: AnimationType.word,
                    slideType: SlideAnimationType.leftRight,
                    textStyle: (GoogleFonts.pacifico(
                        fontWeight: FontWeight.w500,
                        fontSize: 50,
                        color: Colors.white
                    )),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'It takes less than a minute.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _firstNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: AppInputDecorations.authField(label: "First name"),
                    validator: validateName,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _surNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: AppInputDecorations.authField(label: "Surname"),
                    validator: validateName,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: AppInputDecorations.authField(label: "Email"),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: AppInputDecorations.authField(label: "Password",
                      suffixIcon: IconButton(
                      icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),),
                    obscureText: _obscurePassword,
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _confirmPasswordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: AppInputDecorations.authField(label: "Confirm password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),),
                    obscureText: _obscureConfirmPassword,
                    validator: (v) => validateConfirmPassword(_passwordController.text, v),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: AppButtonStyles.primaryPillButtonStyle(),
                    onPressed: _attemptRegister,
                    child: const Text("Create account"),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
