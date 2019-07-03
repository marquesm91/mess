import 'package:flutter/material.dart';
import 'package:mess/services/auth.dart';
import 'package:mess/services/storage.dart';
import 'package:mess/models/user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BaseStorage _storage = Storage();

  void _onClickSignIn() async {
    try {
      User user = await widget.auth.signInWithGoogle();
      await _storage.saveUser(user: user);

      widget.onSignedIn();
    } catch (error) {
      print("Login error: $error");
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
    return ButtonTheme(
      height: 40.0,
      child: RaisedButton(
        onPressed: _onClickSignIn,
        color: Colors.white,
        // highlightColor: Colors.black54,
        // highlightElevation: 2.0,
        // splashColor: Colors.black54,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 24),
              child: Image.asset(
                'assets/google-logo.png',
                height: 20,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Entrar com o Google',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, 0.54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
