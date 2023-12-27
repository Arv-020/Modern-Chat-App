class UserModel {
  final String uid;
  final String email;
  final String username;
  final String token;
  UserModel({required this.token,required this.username ,required this.uid, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(uid: data["uid"], email: data["email"],username: data["username"],token: data["token"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "username":username,
      "token":token
    };
  }
}
