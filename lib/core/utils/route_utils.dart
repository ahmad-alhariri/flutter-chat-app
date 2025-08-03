import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/ui/screens/auth/auth_screen.dart';
import 'package:flutter_chat_app/ui/screens/chat/chat_screen.dart';
import 'package:flutter_chat_app/ui/screens/home/home_screen.dart';
import 'package:flutter_chat_app/ui/screens/splash/splash_screen.dart';

import '../constants/routes.dart';

// ==================================================
// PURPOSE: Centralizes all route generation logic for the app.
// WORKFLOW: When the NavigationService calls `navigateTo('routeName')`, this
// class intercepts that call, finds the matching route in the switch statement,
// and returns the correct screen widget, handling any arguments passed.
// ==================================================
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case Routes.main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case Routes.chat:
      // Safely handle arguments for the chat screen.
        if (settings.arguments is UserModel) {
          final otherUser = settings.arguments as UserModel;
          return MaterialPageRoute(builder: (_) => ChatScreen(otherUser: otherUser));
        }
        // If arguments are not correct, return an error route.
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      );
    });
  }
}