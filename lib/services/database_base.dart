import 'package:firebase_auth/firebase_auth.dart';
import 'package:net_chat/model/mesaj.dart';
import 'package:net_chat/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String yeniUserName);
  //Future<bool> updateProfilFoto(String? userID, String profilFotoURL);
  Future<List<UserModel>> getAllUser();
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
}
