import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  /// Provides a stream of the user's authentication state.
  /// Emits a [User] object if the user is logged in.
  /// Emits `null` if the user is logged out.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

}