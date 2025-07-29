import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';

class SplashViewModel extends ChangeNotifier {
  final AuthService _authService;

  String? _navigationPath;
  String? get navigationPath => _navigationPath;

  bool _hasNavigated = false; // Flag to prevent multiple navigations

  SplashViewModel(this._authService) {
    _handleStartupLogic();
  }

  Future<void> _handleStartupLogic() async {
    _authService.authStateChanges.listen((user) {
      // Prevent navigation if we have already done so.
      if (_hasNavigated) return;

      Timer(const Duration(milliseconds: 1500), () {
        // Double-check after the timer delay.
        if (_hasNavigated) return;

        if (user != null) {
          _navigationPath = home; // Or your path from constants
        } else {
          _navigationPath = auth; // Or your path from constants
        }

        _hasNavigated = true; // Set the flag to true
        notifyListeners();
      });
    });
  }
}
