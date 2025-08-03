import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/core/constants/routes.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/navigation_service.dart';

// ==================================================
// PURPOSE: Manages the state for the ProfileScreen.
// ==================================================
class ProfileViewModel extends BaseViewModel {
  final AuthService _authService;
  final NavigationService _navigationService;
  ProfileViewModel(this._authService, this._navigationService);

  User? get currentUser => _authService.currentUser;

  Future<void> signOut() async {
    await _authService.signOut();
    _navigationService.navigateToAndRemoveUntil(Routes.auth);
  }
}