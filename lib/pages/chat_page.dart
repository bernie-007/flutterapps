import 'package:flutter/material.dart';
import 'package:messaging_firebase_flutter/models/color_model.dart';
import 'package:messaging_firebase_flutter/models/message_model.dart';
import 'package:messaging_firebase_flutter/models/user_model.dart';

class ChatPage extends StatefulWidget {

  final User friend;

  ChatPage({this.friend, Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  double width;
  double height;
  TextEditingController messageController = new TextEditingController();
  bool isSent = false;

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
          widget.friend.name,
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
                child: ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    Message message = messages[messages.length - index - 1];
                    return messageList(context, message);
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
              var jsonMsg = {
                'id': messages.length,
                'sender': currentUser,
                'receiver': widget.friend,
                'text': messageController.text,
                'time': '10:28 PM'
              };
              var newMsg = Message.fromJson(jsonMsg);
              setState(() {
                messageController.text = '';
                messages.add(newMsg);
              });
            },
          )
        ],
      ),
    );
  }

  Widget messageList(BuildContext context, message) {
    User sender = message.sender;
    bool isMe = false;
    if (sender.id == currentUser.id) isMe = true;
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
                message.text,
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
}