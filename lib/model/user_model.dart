import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userID;
  String email;
  String? userName;
  String? profilURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? seviye;

  UserModel({required this.userID,required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ?? "",
      'profilURL': profilURL ?? "",
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye' : seviye ?? 1,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userID = map["userID"] ?? "",
        email = map["email"] ?? "",
        userName = map["userName"],
        profilURL = map["profilURL"],
        createdAt = map["createdAt"] != null
            ? (map["createdAt"] as Timestamp).toDate()
            : null,
        updatedAt = map["updatedAt"] != null
            ? (map["updatedAt"] as Timestamp).toDate()
            : null,
        seviye = map["seviye"];

  @override
String toString() {
  return 'UserModel{\n'
      '  userID: $userID,\n'
      '  email: $email,\n'
      '  userName: ${userName ?? "Not Set"},\n'
      '  profilURL: ${profilURL ?? "Not Set"},\n'
      '  createdAt: ${createdAt != null ? createdAt!.toLocal() : "Not Set"},\n'
      '  updatedAt: ${updatedAt != null ? updatedAt!.toLocal() : "Not Set"},\n'
      '  seviye: ${seviye ?? "Not Set"}\n'
      '}';
}
  

}
