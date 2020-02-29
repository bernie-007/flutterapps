import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:messaging_firebase_flutter/models/color_model.dart';

class ChatPage extends StatefulWidget {

  final Map<String, dynamic> friend;

  ChatPage({this.friend, Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  double width;
  double height;
  bool isSent = false;
  String email;
  int mLength;
  TextEditingController messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
      backgroundColor: appColors.darkColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.friend['name'],
          style: TextStyle(
            color: appColors.lightColor,
            fontSize: height * 0.026
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: width,
                height: height - 140,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('messages')
                            .where('sender', isEqualTo: email)
                            .where('receiver', isEqualTo: widget.friend['email'])
                            .orderBy('date')
                            .orderBy('time')
                            .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Center(
                        child: Text(snapshot.error),
                      );
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            mLength = snapshot.data.documents.length;
                            var message = snapshot.data.documents[mLength - index - 1];
                            return messageList(context, message);
                          },
                        );
                    }
                  },
                ),
              ),
            ),
            composerForm(),
          ],
        ),
      ),
    );
  }

  Widget composerForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      width: width,
      color: appColors.lightColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: messageController,
              style: TextStyle(
                fontSize: height * 0.022
              ),
              decoration: InputDecoration(
                hintText: 'Enter a message here...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: height * 0.036,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _sendMessage();
            },
          )
        ],
      ),
    );
  }

  Widget messageList(BuildContext context, message) {
    bool isMe = false;
    if (message['sender'] == email) isMe = true;
    else isMe = false;
    
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: isMe ? width * 0.4 : 0,
            right: isMe ? 0 : width * 0.4
          ),
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15
              ),
              decoration: BoxDecoration(
                borderRadius: isMe
                ? BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
                )
                : BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)
                ),
                gradient: LinearGradient(
                  colors: isMe
                  ? [appColors.greyColor, appColors.greyLightColor]
                  : [appColors.primaryColor, appColors.primaryLightColor]
                ),
              ),
              child: Text(
                message['text'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.021,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  void _sendMessage() async {
    if (messageController.text != null && messageController.text != '') {
      String text = messageController.text;
      DateTime now = DateTime.now();
      String sentDate = "${now.year}/${now.month}/${now.day}";
      String sentTime = "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute} ${now.hour > 12 ? 'AM' : 'PM'}";
      // store message on real-time database
      Firestore.instance.collection('messages').document()
        .setData({
          'sender': email,
          'receiver': widget.friend['email'],
          'text': messageController.text,
          'time': sentTime,
          'date': sentDate
        });
      // update users collection
      QuerySnapshot qSnapshot = await Firestore.instance.collection('users')
        .where('email', isEqualTo: widget.friend['email'])
        .getDocuments();

      qSnapshot.documents.forEach((dSnapshot) {
        if (mLength != null && mLength > 0) {
          dSnapshot.reference.updateData({
            '${email.toString()}': {
              'time': sentTime,
              'text': text,
              'date': sentDate
            }
          });
        } else {
          dSnapshot.reference.setData({
            '${email.toString()}': {
              'time': sentTime,
              'text': text,
              'date': sentDate
            }
          });
        }
      });
      messageController.text = '';
    }
  }
}