import 'package:flutter/material.dart';
import 'package:mess/pages/user_detail.dart';
import 'package:mess/services/auth.dart';
import 'package:mess/services/storage.dart';
import 'package:mess/utils/colors.dart';
import 'package:mess/models/user.dart';
import 'package:mess/models/mess.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user;
  BaseStorage _storage = Storage();

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

  void _onClicked() async {
    try {
      Mess mess = await _storage.createMess(userId: _user.userId);
      print('mess created: ${mess.description}');
      print('mess created: ${mess.userId}');
      print('mess created: ${mess.groupId}');
      print('mess created: ${mess.date}');
    } catch (error) {
      print('Error: $error');
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
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
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
      body: UserDetail(user: _user, storage: _storage),
      floatingActionButton: FloatingActionButton(
        onPressed: _onClicked,
        backgroundColor: BaseColors.primaryBlack,
        child: Icon(Icons.timer),
      ),
    );
  }
}
