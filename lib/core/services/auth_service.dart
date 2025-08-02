import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  /// Provides a stream of the user's authentication state.
  /// Emits a [User] object if the user is logged in.
  /// Emits `null` if the user is logged out.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.updateDisplayName(username);
    await userCredential.user?.reload();
    return userCredential;
  }
  
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}