import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/services/auth_base.dart';



class FakeAuthService implements AuthBase {
  String userID = "123234343453";

  @override
  Future<UserModel?> currentUser() async {  
    return await Future.value(UserModel(userID: userID));
  }

  @override
  Future<UserModel?> signInAnonymously() async { 
    return await Future.delayed(const Duration(seconds: 2), () => UserModel(userID: userID));
  }

  @override
  Future<bool> signOut() async {  // async ekledim
    return Future.value(true);
  }
  
  @override
  Future<UserModel> singInWithGoogle() async{
    return await Future.delayed(const Duration(seconds: 2), () => UserModel(userID: "google_user_id_123456")); //facebook icinde ayni mantik
    // TODO: implement singInWithGoogle
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel?> createWithEmailAndPassword(String email, String password) async {
    return await Future.delayed(const Duration(seconds: 2), () => UserModel(userID: "created_user_id_123456"));
    // TODO: implement createWithEmalAndPassword
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    return await Future.delayed(const Duration(seconds: 2), () => UserModel(userID: "signIn_user_id_123456"));
    // TODO: implement signInWithEmalAndPassword
    throw UnimplementedError();
  }
}

