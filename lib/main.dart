import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mess/services/auth.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';

const PrimaryBlack = Color(0xff2b2b2b);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mess',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _subs;

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

  void _checkDeepLink(String link) async {
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);

      try {
        FirebaseUser user = await loginWithGitHub(code);
        print("displayName: ${user.displayName}");
        print("photoUrl: ${user.photoUrl}");
      } catch (error) {
        print("LOGIN ERROR: $error");
      }
    }
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 50),
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
      onPressed: signInWithGithub,
      color: Colors.black,
      highlightColor: PrimaryBlack,
      splashColor: Colors.white30,
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              'assets/github-logo.png',
              height: 22,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            'Entrar com Github',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
