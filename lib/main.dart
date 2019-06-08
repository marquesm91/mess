import 'package:flutter/material.dart';
import 'package:mess/services/auth.dart';
import 'package:mess/pages/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mess',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: Auth()),
    );
  }
}
