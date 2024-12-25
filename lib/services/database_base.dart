import 'package:net_chat/model/konusma.dart';
import 'package:net_chat/model/mesaj.dart';
import 'package:net_chat/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String yeniUserName);
  //Future<bool> updateProfilFoto(String? userID, String profilFotoURL);
  Future<List<UserModel>> getAllUser();
  Future<List<Konusma>> getAllConversations(String userID);
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
  Future<DateTime> saatiGoster(String userID);
}
