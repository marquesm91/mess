import 'package:flutter/material.dart';
import 'package:mess/services/auth.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user;

  @override
  void initState() {
    super.initState();

    widget.auth.currentUser().then((user) {
      setState(() {
        _user = user;
      });
    });
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (error) {
      print('Error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: refactor this condition to a StreamBuilder
    // exmaple: https://medium.com/@sidky/using-streambuilder-in-flutter-dcc2d89c2eae
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
          actions: [
            FlatButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
              onPressed: _signOut,
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 75.0,
              backgroundImage: NetworkImage(_user.photoUrl),
              backgroundColor: Colors.transparent,
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                '${_user.displayName}',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
