class User {
  final int id;
  final String name;
  final String avatar;
  final String lastMessage;

  User({
    this.id,
    this.name,
    this.avatar,
    this.lastMessage
  });

  User.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      name = json['fullName'],
      avatar = json['avatar'],
      lastMessage = json['lastMessage'];
}

User currentUser = User(id: 10, name: "Isco", avatar: "");

User user1 = User(id: 1, name: "Mary1", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
User user2 = User(id: 2, name: "Mary2", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
User user3 = User(id: 3, name: "Mary3", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
User user4 = User(id: 4, name: "Mary4", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
User user5 = User(id: 5, name: "Mary5", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
User user6 = User(id: 6, name: "Mary6", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
User user7 = User(id: 7, name: "Mary7", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
User user8 = User(id: 8, name: "Mary8", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
User user9 = User(id: 9, name: "Mary9", avatar: "", lastMessage: "Hi, I am Mary. How are you?");
