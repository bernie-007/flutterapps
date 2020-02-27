import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack/snack.dart';

import 'package:messaging_firebase_flutter/models/color_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

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
                height: height * 2 / 3,
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
                        'Sign In',
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
                      )
                    ),
                    SizedBox(height: height / 20),
                    Container(
                      width: width * 7 / 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: appColors.primaryColor
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          _signInUser(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(3),
                          padding: EdgeInsets.symmetric(vertical: height / 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: height * 0.026,
                                color: appColors.primaryColor
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: width * 7 / 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){},
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: height * 0.018
                              ),
                            ),
                          ),
                          Text(
                            'Sign in with Social',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: height * 0.018
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width * 7 / 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: width / 12,
                              height: width / 12,
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
                              width: width / 10,
                              height: width / 10,
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
                    SizedBox(height: height / 20),
                    Container(
                      width: width * 7 / 8,
                      padding: EdgeInsets.symmetric(vertical: height / 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: appColors.primaryColor
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/SignUp');
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

  void _signInUser(BuildContext context) async {
    FirebaseUser user;
    try {
      user = (await auth.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
      ))
        .user;
    } catch (e) {
      final bar = new SnackBar(content: Text(e.message));
      bar.show(context);
    }
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdToken();
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', tokenResult.token);
      await prefs.setString('email', user.email);
      await prefs.setBool('isEmailVerified', user.isEmailVerified);
      
      Navigator.pushReplacementNamed(context, '/Home');
    }
  }
}