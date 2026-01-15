import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/core/utils/validators/validators.dart';
import 'package:joby/state/auth/models/auth_result.dart';
import 'package:joby/state/auth/providers/authentication_provider.dart';
import 'package:joby/features/auth/presentation/widgets/divider_with_margins.dart';
import 'package:joby/theme/app_colors.dart';
import 'package:joby/theme/app_strings.dart';




class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    print('Login attempted');
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      print("Email: $email");
      print("Password: $password");

      final authProvider = ref.read(authenticationProvider.notifier);
      await authProvider.loginWithEmailAndPassword(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = ref.watch(authenticationProvider);

    ref.listen(authenticationProvider, (previous, next) {
      print('previous: $previous and current: $next');
      if (next. result == AuthResult.failure && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong Email or Password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
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
                    Text(
                      "Welcome to JobY",
                      style: Theme
                          .of(context)
                          .textTheme
                          .displaySmall,
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
                      obscureText: true,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.loginButtonTextColor,
                      ),
                      onPressed: authProvider.isLoading ? null : _attemptLogin,
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
        )
    );
  }
}
