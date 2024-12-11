import 'package:net_chat/model/user.dart';

abstract class AuthBase {
  Future<UserModel?> currentUser();
  Future<UserModel?> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel?> singInWithGoogle();
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> createWithEmailAndPassword(String email, String password);
  
}
