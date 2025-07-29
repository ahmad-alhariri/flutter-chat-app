import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_chat_app/ui/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Controller for the background gradient animation
  late AnimationController _backgroundAnimationController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  // NEW: Controller for the logo's pulsating animation
  late AnimationController _logoAnimationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // -- Setup for Background Animation --
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _topAlignmentAnimation = Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight).animate(_backgroundAnimationController);
    _bottomAlignmentAnimation = Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.bottomRight).animate(_backgroundAnimationController);
    _backgroundAnimationController.repeat(reverse: true);

    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeInOut),
    );
    _logoAnimationController.repeat(reverse: true);

    // -- Navigation Timer --
    _startTimer();
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      _navigate();
    });
  }

  void _navigate() {
    // Todo: check the user's authentication state here.
    bool isLoggedIn = false; // <-- Placeholder for your auth logic

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // --- Animated Background ---
          AnimatedBuilder(
            animation: _backgroundAnimationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: _topAlignmentAnimation.value,
                    end: _bottomAlignmentAnimation.value,
                  ),
                ),
              );
            },
          ),
          // --- Foreground Content (Logo and Text) ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // NEW: Wrapped the logo in a ScaleTransition for the animation.
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    logo,
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Chatter',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}