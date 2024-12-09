import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/services/database_base.dart';

class FirestoreDbService implements DBBase{
  
  final FirebaseFirestore _firebaseAuth = FirebaseFirestore.instance; // Firestore degil artik 

  @override
  Future<bool> saveUser(UserModel userModel) async {
    await _firebaseAuth.collection("userModels").doc(userModel.userID).set(userModel.toMap());


    // TODO: implement saveUser
    //throw UnimplementedError(); // return null da hata aldim
    return true;
  }

}