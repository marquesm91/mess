import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:mess/services/auth.dart';
import 'package:mess/services/storage.dart';
import 'package:mess/models/user.dart';
import 'package:mess/utils/colors.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription _subs;
  BaseStorage _storage = Storage();

  @override
  void initState() {
    _initDeepLinkListener();
    super.initState();
  }

  @override
  void dispose() {
    _disposeDeepLinkListener();
    super.dispose();
  }

  void _initDeepLinkListener() async {
    _subs = getLinksStream().listen((String link) {
      _checkDeepLink(link);
    }, cancelOnError: true);
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

  void _checkDeepLink(String link) async {
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);

      try {
        User user = await widget.auth.signInWithGithub(code);
        await _storage.saveUser(user: user);

        widget.onSignedIn();
      } catch (error) {
        print("Login error: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: Image.asset(
                'assets/mess-logo.png',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: githubSignInButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget githubSignInButton() {
    return RaisedButton(
      onPressed: openGithubAuth,
      color: Colors.black,
      highlightColor: BaseColors.primaryBlack,
      splashColor: Colors.white30,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              'assets/github-logo.png',
              height: 22,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            'Entrar com Github',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
