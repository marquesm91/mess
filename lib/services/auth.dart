import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:mess/models/user.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword({String email, String password});
  Future<String> createUserWithEmailAndPassword(
      {String email, String password});
  Future<User> signInWithGoogle();
  Future<User> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      {String email, String password}) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return user.uid;
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);

    return User(
      userId: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  Future<User> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    if (user == null) {
      return null;
    }

    return User(
      userId: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
