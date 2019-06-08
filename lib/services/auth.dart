import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mess/utils/constants.dart';
import 'package:mess/models/user.dart';
import 'package:mess/models/github_login_request.dart';
import 'package:mess/models/github_login_response.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword({String email, String password});
  Future<String> createUserWithEmailAndPassword(
      {String email, String password});
  Future<User> signInWithGithub(String code);
  Future<User> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  Future<User> signInWithGithub(String code) async {
    final response = await http.post(
      "https://github.com/login/oauth/access_token",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(GitHubLoginRequest(
        clientId: Constants.githubClientId,
        clientSecret: Constants.githubClientSecret,
        code: code,
      )),
    );

    GitHubLoginResponse loginResponse =
        GitHubLoginResponse.fromJson(json.decode(response.body));

    final AuthCredential credential = GithubAuthProvider.getCredential(
      token: loginResponse.accessToken,
    );

    final FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);

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

void openGithubAuth() async {
  const String url = "https://github.com/login/oauth/authorize" +
      "?client_id=" +
      Constants.githubClientId +
      "&scope=read:user%20user:email";

  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    print('cannot launch url');
  }
}
