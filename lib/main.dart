import 'package:flutter/material.dart';
import 'package:todo/pages/security/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'x',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(58, 62, 82, 1.0),
        accentColor: Colors.white,
        backgroundColor: Color.fromRGBO(43, 45, 60, 1.0),
        buttonColor: Color.fromRGBO(0, 74, 143, 1.0),
        // primarySwatch: Colors.red
      ),
      home: Splash(),
    );
  }
}

