import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack/snack.dart';

import 'package:messaging_firebase_flutter/models/color_model.dart';
import 'package:messaging_firebase_flutter/models/user_model.dart';
import 'package:messaging_firebase_flutter/pages/chat_page.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double width;
  double height;
  String removeItem = "";
  String callItem = "";
  double posX = 0, posY = 0; // distance of geolocation between first position and drag update position
  double fPosX = 0, fPosY = 0; // first geolocation when drag start

  // currentUser
  String email;
  String name;
  String token;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
      backgroundColor: appColors.greyColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: appColors.lightColor,
            size: height * 0.03,
          ), 
          onPressed: (){}
        ),
        title: Text(
          "Welcome, ${currentUser.name}",
          style: TextStyle(
            color: appColors.lightColor,
            fontSize: height * 0.026
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: height * 0.03,
              color: appColors.lightColor
            ), 
            onPressed: () async {
              _signOutUser(context);
            }
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('user').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error),
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data.documents[index];
                  return GestureDetector(
                    onTap: () {
                      _chatWithUser(user1);
                    },
                    onHorizontalDragStart: (DragStartDetails details) {
                      fPosX = details.globalPosition.dx;
                      fPosY = details.globalPosition.dy;
                    },
                    onHorizontalDragEnd: (DragEndDetails details) {
                      setState(() {
                        if (posX > 50) {
                          if (removeItem != doc['email']) callItem = doc['email'];
                          removeItem = "";
                        } else if (posX < -50) {
                          if (callItem != doc['email']) removeItem = doc['email'];
                          callItem = "";
                        }
                      });
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                      posX = fPosX - details.globalPosition.dx;
                      posY = fPosY - details.globalPosition.dy;
                    },
                    child: callItem == doc['email']
                    ? callLayout(context, doc)
                    : removeItem == doc['email']
                    ? removeLayout(context, doc)
                    : normalLayout(context, doc)
                  );
                },
              );
          }
        }
      ),
    );
  }

  Widget normalLayout(BuildContext context, DocumentSnapshot user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.1),
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 5
      ),
      color: appColors.darkColor,
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: height * 0.07,
            height: height * 0.07,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/man.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                user['name'] != null ? user['name'] : "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.024
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: width * 0.6,
                child: Text(
                  user['lasts'][email]['text'] != null ? user['lasts'][email]['text'] : "",
                  style: TextStyle(
                    color: appColors.greyColor,
                    fontSize: height * 0.021
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            user['lasts'][email]['text'] != null ? user['lasts'][email]['text'] : "",
            style: TextStyle(
              color: appColors.greyColor,
              fontSize: height * 0.021
            ),
          ),
        ],
      ),
    );
  }

  Widget callLayout(BuildContext context, DocumentSnapshot user) {
    return Container(
      color: appColors.darkColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: width * 0.85,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      user['name'] != null ? user['name'] : "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.024
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: width * 0.5,
                      child: Text(
                        user['lasts'][email]['text'] != null ? user['lasts'][email]['text'] : "",
                        style: TextStyle(
                          color: appColors.greyColor,
                          fontSize: height * 0.021
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Text(
                  user['lasts'][email]['text'] != null ? user['lasts'][email]['text'] : "",
                  style: TextStyle(
                    color: appColors.greyColor,
                    fontSize: height * 0.021
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            color: appColors.pinkColor,
            width: width * 0.15,
            padding: EdgeInsets.only(
              top: 16,
              bottom: 16
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                    size: height * 0.033,
                  ), 
                  onPressed: (){}
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget removeLayout(BuildContext context, DocumentSnapshot user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.1),
      color: appColors.darkColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: appColors.primaryColor,
            width: width * 0.4,
            padding: EdgeInsets.symmetric(
              vertical: 16
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: height * 0.033,
                  ), 
                  onPressed: (){}
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '101',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.024
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'messages',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.021
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: height * 0.07,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/man.jpg'),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      user['name'] != null ? user['name'] : "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.024
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: width * 0.3,
                      child: Text(
                        user['lasts'][email]['text'] != null ? user['lasts'][email]['text'] : "",
                        style: TextStyle(
                          color: appColors.greyColor,
                          fontSize: height * 0.021
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    token = prefs.getString('token');
  }
  
  void _chatWithUser(User friend) {
    setState(() {
      callItem = "";
      removeItem = "";
    });
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ChatPage(friend: friend)
      )
    );
  }
  void _signOutUser(BuildContext context) async {
    try {
      await auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pop(context);
    } catch (e) {
      final bar = new SnackBar(content: Text(e.message));
      bar.show(context);
    }
  }
}