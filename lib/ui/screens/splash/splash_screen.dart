import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_chat_app/ui/screens/auth/auth_screen.dart';
import 'package:flutter_chat_app/ui/screens/home/home_screen.dart';
import 'package:flutter_chat_app/ui/screens/splash/splash_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  late AnimationController _logoAnimationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    // Get the ViewModel from Provider, but don't listen for changes yet.
    final splashViewModel = context.read<SplashViewModel>();

    // Listen to the navigationPath property of the ViewModel.
    splashViewModel.addListener(() {
      if (mounted && splashViewModel.navigationPath != null) {
        _navigate(splashViewModel.navigationPath!);
      }
    });
  }

  void _setupAnimations() {
    _backgroundAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _topAlignmentAnimation = Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight).animate(_backgroundAnimationController);
    _bottomAlignmentAnimation = Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.bottomRight).animate(_backgroundAnimationController);

    _logoAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  void _navigate(String path) {
    Widget screen;
    if (path == home) {
      screen = const MainScreen();
    } else {
      screen = const AuthScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    logo, // Make sure 'logo' is a valid constant in your paths file
                    width: 120.w,
                    height: 120.h,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Chatter',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                    fontSize: 24.sp,
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
