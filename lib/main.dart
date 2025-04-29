import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'welcome_page.dart';

void main() {
  runApp(MyApp());
}
//change
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(),
      routes: {
        '/welcome': (context) => WelcomePage(),
      },
    );
  }
}
