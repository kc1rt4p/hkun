import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credentials;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    final user = _auth.currentUser;
    print('current user: $user');
    return user != null;
  }
}
