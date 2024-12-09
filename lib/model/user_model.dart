class UserModel {
  final String userID;
  

  UserModel({required this.userID});

  Map<String, dynamic> toMap() {
    return {
      'userModelID' : userID,

    };
  }

}
