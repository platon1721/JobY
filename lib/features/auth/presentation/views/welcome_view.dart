import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/features/auth/presentation/widgets/gradient_background.dart';
import 'package:joby/theme/app_colors.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    // Show logo after the text animation (4s) + small extra pause
    Future.delayed(const Duration(milliseconds: 4300), () {
      if (!mounted) return;
      setState(() => _showLogo = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OffsetText(
                text: 'Welcome to',
                duration: const Duration(seconds: 4),
                type: AnimationType.word,
                slideType: SlideAnimationType.leftRight,
                textStyle: GoogleFonts.pacifico(
                  fontWeight: FontWeight.w500,
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
              AnimatedOpacity(
                opacity: _showLogo ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: Image.asset(
                  'assets/images/jobY.png',
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.loginButtonTextColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => context.push('/login'),
                      child: const Text("Login", style: TextStyle(
                          color: Colors.white,fontSize: 18)),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.loginButtonTextColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => context.push('/register'),
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
