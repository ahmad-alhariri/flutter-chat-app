import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/core/constants/routes.dart';
import 'package:flutter_chat_app/core/enums/enums.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/core/services/navigation_service.dart';


// ==================================================
// PURPOSE: Manages the state for the ContactsScreen.
// ==================================================
class ContactsViewModel extends BaseViewModel {
  final DatabaseService _databaseService;
  final NavigationService _navigationService;
  final User? _user;

  ContactsViewModel(this._databaseService, this._navigationService, this._user) {
    getUsers();
  }

  Stream<List<UserModel>>? usersStream;

  void getUsers() {
    if (_user != null) {
      setState(ViewState.Busy);
      usersStream = _databaseService.getUsersStream(_user!.uid);
      setState(ViewState.Idle);
    } else if(_user == null){
      // If the user is null (logged out), set the stream to null
      usersStream = null;
      setState(ViewState.Idle);
    }
    else {
      setState(ViewState.Error, message: "User not logged in.");
    }
  }

  void navigateToChat(UserModel otherUser) {
    _navigationService.navigateTo(Routes.chat, arguments: otherUser);
  }
}