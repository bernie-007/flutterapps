import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messaging_firebase_flutter/models/color_model.dart';
import 'package:messaging_firebase_flutter/pages/home_page.dart';
import 'package:messaging_firebase_flutter/pages/signin_page.dart';
import 'package:messaging_firebase_flutter/pages/signup_page.dart';
import 'package:messaging_firebase_flutter/pages/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging Flutter App',
      theme: ThemeData(
        primaryColor: appColors.primaryColor
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/SignIn': (BuildContext context) => new SigninPage(),
        '/SignUp': (BuildContext context) => new SignupPage(),
        '/Home': (BuildContext context) => new HomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isSplash = true;

  @override
  void initState() {
    super.initState();
    isSplash = true;
  }

  @override
  Widget build(BuildContext context) {
    new Timer(Duration(seconds: 10), () {
      if (mounted)
        setState(() {
          isSplash = false;
        });
    });
    return isSplash ? SplashPage() : SigninPage();
  }
}
