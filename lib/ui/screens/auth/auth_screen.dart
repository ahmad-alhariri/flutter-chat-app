import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/screens/auth/login/login_view.dart';
import 'package:flutter_chat_app/ui/screens/auth/signup/signup_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLoginView = true;

  void _toggleView() {
    setState(() {
      _showLoginView = !_showLoginView;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginView) {
      return LoginView(onToggleView: _toggleView);
    } else {
      return SignupView(onToggleView: _toggleView);
    }
  }
}