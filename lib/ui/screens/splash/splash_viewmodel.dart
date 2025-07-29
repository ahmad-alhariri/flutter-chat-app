import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';

class SplashViewModel extends ChangeNotifier {
  final AuthService _authService;

  String? _navigationPath;
  String? get navigationPath => _navigationPath;

  SplashViewModel(this._authService) {
    _handleStartUpLogic();
  }

  Future<void> _handleStartUpLogic() async {
    // Listen to the first event from the auth state stream.
    _authService.authStateChanges.listen((user) {
      // Allow animations to run for a minimum duration for a smoother UX.
      Timer(const Duration(microseconds: 2000), () {
        if (user == null) {
          _navigationPath = auth;
        } else {
          _navigationPath = home;
        }
        // Notify listeners that the navigation path is ready.
        notifyListeners();
      });
    });
  }
}
