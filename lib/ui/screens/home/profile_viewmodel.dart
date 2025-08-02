import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';

class ProfileViewModel extends BaseViewModel {
  final AuthService _authService;
  ProfileViewModel(this._authService);

  User? get currentUser => _authService.currentUser;

  Future<void> signOut() async {
    await _authService.signOut();
  }
}