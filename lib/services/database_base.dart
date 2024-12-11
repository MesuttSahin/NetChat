import 'package:net_chat/model/user.dart';

abstract class  DBBase{
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userID);

}