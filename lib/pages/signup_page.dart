import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snack/snack.dart';

import 'package:messaging_firebase_flutter/models/color_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
      backgroundColor: appColors.primaryColor,
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Container(
                height: height / 3,
                child: Center(
                  child: Container(
                    width: width < height ? width / 4.5 : height / 4.5,
                    height: width < height ? width / 4.5 : height / 4.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                ),
              ),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: width / 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: height / 30,
                      ),
                      child: Text(
                        'Create account',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(height: height / 20),
                    Container(
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(
                          fontSize: height * 0.023,
                          color: Colors.black
                        ),
                        cursorColor: appColors.primaryColor,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email, 
                            size: height * 0.033, 
                            color: Colors.grey,
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: height * 0.023
                          ),
                        ),
                      )
                    ),
                    SizedBox(height: height / 35),
                    Container(
                      child: TextField(
                        controller: passwordController,
                        style: TextStyle(
                          fontSize: height * 0.023,
                          color: Colors.black
                        ),
                        cursorColor: appColors.primaryColor,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key, 
                            size: height * 0.033, 
                            color: Colors.grey,
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: height * 0.023
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: height * 0.1),
                    Container(
                      width: width * 7 / 8,
                      padding: EdgeInsets.symmetric(vertical: height / 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: appColors.primaryColor
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          _signUpUser(context);
                        },
                        child: Center(
                          child: Text(
                            'Create account',
                            style: TextStyle(
                              fontSize: height * 0.026,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Container(
                      width: width * 7 / 8,
                      child: Center(
                        child: Text(
                          'Continue with Social',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: height * 0.019
                          ),
                        ),
                      )
                    ),
                    Container(
                      width: width * 7 / 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: width / 9,
                              height: width / 9,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/google-icon.jpg"),
                                  fit: BoxFit.cover
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: width / 7,
                              height: width / 7,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/facebook-icon.jpg"),
                                  fit: BoxFit.cover
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.05)
                  ],
                )
              )
            ],
          );
        }
      )
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signUpUser(BuildContext context) async {
    FirebaseUser user;
    
    try {
      user = (await auth.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
      ))
        .user;
    } catch (e) {
      print(e.code);
      print(e.message);
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        final bar = SnackBar(content: Text(e.message));
        bar.show(context);
      }
    }
    if (user != null) {
      _pushUserInfo();
      Navigator.pop(context);
    }
  }

  void _pushUserInfo() async {
    Firestore.instance.collection('users').document()
      .setData({
        'name': '',
        'email': emailController.text,
        'password': passwordController.text
      });
  }
}