import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:messaging_firebase_flutter/models/color_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
      backgroundColor: appColors.lightColor,
      body: Center(
        child: Container(
          width: width < height ? width / 4.5 : height / 4.5,
          height: width < height ? width / 4.5 : height / 4.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/logo.png"),
              fit: BoxFit.cover
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseUser user;
    try {
      user = await auth.currentUser();
      print(user);
    } on PlatformException catch(e) {
      
    }
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdToken();
      if (tokenResult.token != null) {
        await prefs.setString('email', user.email);
        await prefs.setString('token', tokenResult.token);
        await prefs.setBool('isEmailVerified', user.isEmailVerified);
        Navigator.pushReplacementNamed(context, '/Home');
      }
    }
  }
}