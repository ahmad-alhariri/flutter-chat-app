import 'dart:async';

import 'package:flutter_chat_app/core/constants/routes.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/navigation_service.dart';

// ==================================================
// PURPOSE: Manages the business logic for the Splash Screen.
// WORKFLOW: It listens to the auth state from AuthService and, after a delay,
// tells the NavigationService to navigate to the appropriate screen (Main or Auth).
// ==================================================
class SplashViewModel extends BaseViewModel {
  final AuthService _authService;
  final NavigationService _navigationService;
  bool _hasNavigated = false;

  SplashViewModel(this._authService, this._navigationService) {
    _handleStartupLogic();
  }

  Future<void> _handleStartupLogic() async {
    _authService.authStateChanges.listen((user) {
      if (_hasNavigated) return;
      Timer(const Duration(milliseconds: 2000), () {
        if (_hasNavigated) return;
        final route = user != null ? Routes.main : Routes.auth;
        _navigationService.navigateToAndRemoveUntil(route);
        _hasNavigated = true;
      });
    });
  }
}
