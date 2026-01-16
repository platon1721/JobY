import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/core/utils/validators/validators.dart';
import 'package:joby/features/auth/presentation/controllers/auth_controller.dart';
import 'package:joby/features/auth/presentation/controllers/auth_state.dart';
import 'package:joby/features/auth/presentation/widgets/divider_with_margins.dart';
import 'package:joby/features/auth/presentation/widgets/gradient_background.dart';
import 'package:joby/theme/app_colors.dart';
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
          title: Text(AppStrings.appTitle, style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color: Colors.white
          )),
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
                      text: 'Welcome to JobY',
                      duration: const Duration(seconds: 4),
                      type: AnimationType.word,
                      slideType: SlideAnimationType.leftRight,
                      textStyle: (GoogleFonts.pacifico(
                          fontWeight: FontWeight.w500,
                          fontSize: 50,
                          color: Colors.white
                      )),
                    ),
                    const  DividerWithMargins(20),
                    // Subheader
                    Text(
                      "Login into your account",
                      style: Theme
                          .of(context)
                          .
                      textTheme
                          .
                      bodyMedium
                          ?.copyWith(height: 1.5
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.loginButtonTextColor,
                      ),
                      onPressed: _attemptLogin,
                      child: const Text("Login"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.loginButtonTextColor,
                      ),
                      onPressed: () {
                        print("Register");
                        context.push('/register');
                      },
                      child: const Text("Register", style: TextStyle(color: Colors.white),),
                    ),
                    const DividerWithMargins(20),
                  ]
              ),
            ),
          ),
        ))
    );

    // return Scaffold(
    //   body: SafeArea(
    //     child: Center(
    //       child: SingleChildScrollView(
    //         padding: const EdgeInsets.all(24.0),
    //         child: Form(
    //           key: _formKey,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               // Logo/Title
    //               const Icon(
    //                 Icons.lock_outline,
    //                 size: 80,
    //                 color: Colors.blue,
    //               ),
    //               const SizedBox(height: 16),
    //               Text(
    //                 'Welcome Back',
    //                 style: Theme.of(context).textTheme.headlineMedium,
    //                 textAlign: TextAlign.center,
    //               ),
    //               const SizedBox(height: 8),
    //               Text(
    //                 'Sign in to continue',
    //                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    //                       color: Colors.grey[600],
    //                     ),
    //                 textAlign: TextAlign.center,
    //               ),
    //               const SizedBox(height: 48),
    //
    //               // Email field
    //               TextFormField(
    //                 controller: _emailController,
    //                 keyboardType: TextInputType.emailAddress,
    //                 decoration: const InputDecoration(
    //                   labelText: 'Email',
    //                   hintText: 'Enter your email',
    //                   prefixIcon: Icon(Icons.email_outlined),
    //                   border: OutlineInputBorder(),
    //                 ),
    //                 validator: (value) {
    //                   if (value == null || value.isEmpty) {
    //                     return 'Please enter your email';
    //                   }
    //                   if (!value.contains('@')) {
    //                     return 'Please enter a valid email';
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               const SizedBox(height: 16),
    //
    //               // Password field
    //               TextFormField(
    //                 controller: _passwordController,
    //                 obscureText: _obscurePassword,
    //                 decoration: InputDecoration(
    //                   labelText: 'Password',
    //                   hintText: 'Enter your password',
    //                   prefixIcon: const Icon(Icons.lock_outlined),
    //                   suffixIcon: IconButton(
    //                     icon: Icon(
    //                       _obscurePassword
    //                           ? Icons.visibility_outlined
    //                           : Icons.visibility_off_outlined,
    //                     ),
    //                     onPressed: () {
    //                       setState(() {
    //                         _obscurePassword = !_obscurePassword;
    //                       });
    //                     },
    //                   ),
    //                   border: const OutlineInputBorder(),
    //                 ),
    //                 validator: (value) {
    //                   if (value == null || value.isEmpty) {
    //                     return 'Please enter your password';
    //                   }
    //                   if (value.length < 6) {
    //                     return 'Password must be at least 6 characters';
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               const SizedBox(height: 8),
    //
    //               // Forgot password
    //               Align(
    //                 alignment: Alignment.centerRight,
    //                 child: TextButton(
    //                   onPressed: () {
    //                     // Navigate to forgot password screen
    //                     Navigator.of(context).pushNamed('/forgot-password');
    //                   },
    //                   child: const Text('Forgot Password?'),
    //                 ),
    //               ),
    //               const SizedBox(height: 24),
    //
    //               // Login button
    //               authState.maybeWhen(
    //                 loading: () => const Center(
    //                   child: CircularProgressIndicator(),
    //                 ),
    //                 orElse: () => ElevatedButton(
    //                   onPressed: _attemptLogin,
    //                   style: ElevatedButton.styleFrom(
    //                     padding: const EdgeInsets.symmetric(vertical: 16),
    //                   ),
    //                   child: const Text(
    //                     'Login',
    //                     style: TextStyle(fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(height: 16),
    //
    //               // Register link
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   const Text("Don't have an account?"),
    //                   TextButton(
    //                     onPressed: () {
    //                       Navigator.of(context).pushNamed('/register');
    //                     },
    //                     child: const Text('Register'),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
