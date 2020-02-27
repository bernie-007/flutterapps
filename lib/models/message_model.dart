import 'package:messaging_firebase_flutter/models/user_model.dart';

class Message {
  final int id;
  final User sender;
  final User receiver;
  final String text;
  final String time;

  Message({
    this.id,
    this.sender,
    this.receiver,
    this.text,
    this.time
  });

  Message.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      sender = json['sender'],
      receiver = json['receiver'],
      text = json['text'],
      time = json['time'];
}

Message message1 = Message(
  id: 1,
  sender: user1,
  receiver: currentUser,
  text: "Hi, How are you?",
  time: "12:14 PM"
);

Message message2 = Message(
  id: 2,
  sender: currentUser,
  receiver: user1,
  text: "I am fine, yourself?",
  time: "12:14 PM"
);

Message message3 = Message(
  id: 3,
  sender: user1,
  receiver: currentUser,
  text: "I am fine, too. Thanks",
  time: "12:14 PM"
);

List<Message> messages = [message1, message2, message3];
List<User> users = [user1, user2, user3, user4, user5, user6, user7, user8, user9];