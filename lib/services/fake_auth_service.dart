import 'package:net_chat/model/user.dart';
import 'package:net_chat/services/auth_base.dart';



class FakeAuthService implements AuthBase {
  String userID = "123234343453";

  @override
  Future<UserModel?> currentUser() async {  
    return await Future.value(UserModel(userID: userID,email: "fakeUser@example.com"));
  }

  @override
  Future<UserModel?> signInAnonymously() async { 
    return await Future.delayed(const Duration(seconds: 2), () => UserModel(userID: userID,email: "fakeUser@example.com"));
  }

  @override
  Future<bool> signOut() async {  // async ekledim
    return Future.value(true);
  }
  
  @override
  Future<UserModel> singInWithGoogle() async{
    return await Future.delayed(const Duration(seconds: 2), () => UserModel(userID: "google_user_id_123456",email: "fakeUser@example.com")); //facebook icinde ayni mantik
    
  }
  
  @override
  Future<UserModel?> createWithEmailAndPassword(String email, String password) async {
    return await Future.delayed(const Duration(seconds: 2), () => UserModel(userID: "created_user_id_123456",email: "fakeUser@example.com"));
   
  }
  
  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    return await Future.delayed(const Duration(seconds: 2), () => UserModel(userID: "signIn_user_id_123456",email: "fakeUser@example.com"));
   
  }
}

