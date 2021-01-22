class UserService {
  String userName = "filledstacks";
}

class User {
  final String username;
  final String password;
  final int age;

  User({this.username, this.password, this.age});

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        age = json['age'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['age'] = this.age;
    return data;
  }
}