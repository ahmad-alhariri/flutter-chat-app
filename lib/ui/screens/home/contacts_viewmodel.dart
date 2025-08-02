import 'package:flutter_chat_app/core/enums/enums.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';

class ContactsViewModel extends BaseViewModel {
  final DatabaseService _databaseService;
  final AuthService _authService;

  ContactsViewModel(this._databaseService, this._authService) {
    getUsers();
  }

  Stream<List<UserModel>>? usersStream;

  void getUsers() {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      setState(ViewState.Busy);
      usersStream = _databaseService.getUsersStream(userId);
      setState(ViewState.Idle);
    } else {
      setState(ViewState.Error, message: "User not logged in.");
    }
  }
}