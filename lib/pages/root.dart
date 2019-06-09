import 'package:flutter/material.dart';
import 'package:mess/services/auth.dart';
import 'package:mess/models/auth_status.dart';
import 'package:mess/pages/rank.dart';
import 'package:mess/pages/login.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();

    widget.auth.currentUser().then((user) {
      setState(() {
        _authStatus =
            user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return RankPage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
      default:
        return null;
    }
  }
}
