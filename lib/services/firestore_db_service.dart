import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:net_chat/model/user.dart';
import 'package:net_chat/services/database_base.dart';

class FirestoreDbService implements DBBase {
  final FirebaseFirestore _firebaseDB =
      FirebaseFirestore.instance; // Firestore degil artik

  @override
  Future<bool> saveUser(UserModel userModel) async {
    await _firebaseDB
        .collection("userModels")
        .doc(userModel.userID)
        .set(userModel.toMap());

    DocumentSnapshot _okunanUser = await FirebaseFirestore.instance
        .doc("userModels/${userModel.userID}")
        .get();

    Map<String, dynamic>? _okunanUserBilgiMap =
        _okunanUser.data() as Map<String, dynamic>;
    UserModel _okunanUserBilgiNesne = UserModel.fromMap(_okunanUserBilgiMap);
    print("Okunan User Nesnesi : " + _okunanUserBilgiNesne.toString());

    return true;
  }
  
@override
Future<UserModel> readUser(String userID) async {
DocumentSnapshot _okunanUser = await _firebaseDB.collection("userModels").doc(userID).get();


  // Null kontrolü yapılarak data() güvenli şekilde işleniyor
  Map<String, dynamic>? _okunanUserBilgileriMap =
      _okunanUser.data() as Map<String, dynamic>?;

  if (_okunanUserBilgileriMap != null) {
    UserModel _okunanUserNesnesi =
        UserModel.fromMap(_okunanUserBilgileriMap);
    print("Okunan user nesnesi : " + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  } else {
    throw Exception("Kullanıcı bulunamadı.");
  }
}

}
