import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/viewmodels/auth_viewmodel.dart';
import 'package:flutter_chat_app/ui/screens/auth/login/login_view.dart';
import 'package:flutter_chat_app/ui/screens/auth/signup/signup_view.dart';
import 'package:provider/provider.dart';

// ==================================================
// PURPOSE: A stateful widget that acts as a container to toggle
// between the LoginView and SignupView.
// ==================================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLoginView = true;

  void _toggleView() {
    // Clear any previous errors when toggling the view.
    context.read<AuthViewModel>().clearError();
    setState(() => _showLoginView = !_showLoginView);
  }

  @override
  Widget build(BuildContext context) {
    return _showLoginView
        ? LoginView(onToggleView: _toggleView)
        : SignupView(onToggleView: _toggleView);
  }
}