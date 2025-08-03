import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/core/constants/routes.dart';
import 'package:flutter_chat_app/core/enums/enums.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_service.dart';
import 'package:flutter_chat_app/core/services/navigation_service.dart';


// ==================================================
// PURPOSE: Manages the state and logic for the authentication process.
// WORKFLOW: The UI calls methods like `signIn`. This ViewModel sets the state to
// `Busy`, calls the appropriate services (AuthService, DatabaseService), and upon
// completion, uses the NavigationService to move to the main app.
// ==================================================
class AuthViewModel extends BaseViewModel {
  final AuthService _authService;
  final DatabaseService _databaseService;
  final NavigationService _navigationService;

  AuthViewModel(this._authService, this._databaseService, this._navigationService);

  void clearError() {
    if (state == ViewState.Error) {
      setState(ViewState.Idle);
    }
  }

  Future<void> signIn(String email, String password) async {
    setState(ViewState.Busy);
    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(ViewState.Idle);
      _navigationService.navigateToAndRemoveUntil(Routes.main);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(ViewState.Error, message: 'Email or Password is incorrect');
      } else if (e.code == 'wrong-password') {
        setState(ViewState.Error, message: 'Email or Password is incorrect');
      } else {
        setState(ViewState.Error, message: e.message);
      }
    } catch (e) {
      setState(ViewState.Error, message: e.toString());
    }
  }

  Future<void> signUp(String email, String password, String userName) async {
    setState(ViewState.Busy);
    try {
      UserCredential userCredential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        username: userName,
      );

      if(userCredential.user != null){
        UserModel newUser = UserModel(
          uid: userCredential.user!.uid,
          username: userName,
          email: email,
        );

        await _databaseService.createUser(newUser);
      }


      setState(ViewState.Idle);
      _navigationService.navigateToAndRemoveUntil(Routes.main);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(
          ViewState.Error,
          message: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        setState(
          ViewState.Error,
          message: 'The account already exists for that email.',
        );
      } else {
        setState(ViewState.Error, message: e.message);
      }
    } catch (e) {
      setState(ViewState.Error, message: e.toString());
    }
  }
}
