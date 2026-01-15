import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joby/core/utils/validators/validators.dart';
import 'package:joby/state/auth/models/auth_result.dart';
import 'package:joby/state/auth/providers/authentication_provider.dart';
import 'package:joby/state/auth/providers/is_logged_in_provider.dart';
import 'package:joby/features/auth/presentation/widgets/divider_with_margins.dart';
import 'package:joby/theme/app_colors.dart';
import 'package:joby/theme/app_strings.dart';





class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Future<void> _attemptRegister() async {
    print('Register attempted');
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      print("Email: $email");
      print("Password: $password");
      print("Name: $name");

      final authProvider = ref.read(authenticationProvider.notifier);
      await authProvider.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    // If user is registered successfully, redirect to home
    ref.listen(isLoggedInProvider, ((_, isLoggedIn) {
      context.pop();
    }));


    ref.listen(authenticationProvider, (previous, next) {
      print('previous: $previous and current: $next');
      if (next.result == AuthResult.userAlreadyExists && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User with this email already exists'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next.result == AuthResult.tooManyRequests && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Too many requests, try again later'),
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
                      'Sing up',
                      style: Theme
                          .of(context)
                          .textTheme
                          .displaySmall,
                    ),
                    const  DividerWithMargins(20),
                    // Subheader
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      validator: validateName,
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
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.loginButtonTextColor,
                      ),
                      onPressed: () {
                        print("Register");
                        _attemptRegister();
                      },
                      child: const Text("Register", style: TextStyle(color: Colors.white)),
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
