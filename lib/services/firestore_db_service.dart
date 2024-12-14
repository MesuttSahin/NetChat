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
    DocumentSnapshot _okunanUser =
        await _firebaseDB.collection("userModels").doc(userID).get();

    // Null kontrolü yapılarak data() güvenli şekilde işleniyor
    Map<String, dynamic>? _okunanUserBilgileriMap =
        _okunanUser.data() as Map<String, dynamic>?;

    if (_okunanUserBilgileriMap != null) {
      UserModel _okunanUserNesnesi = UserModel.fromMap(_okunanUserBilgileriMap);
      print("Okunan user nesnesi : " + _okunanUserNesnesi.toString());
      return _okunanUserNesnesi;
    } else {
      throw Exception("Kullanıcı bulunamadı.");
    }
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var users = await _firebaseDB
        .collection("userModels")
        .where("userName", isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection("userModels")
          .doc(userID)
          .update({'userName': yeniUserName});
      return true;
    }
  }

  Future<bool> updateProfilFoto(String? userID, String profilFotoURL) async {
    await _firebaseDB
        .collection("userModels")
        .doc(userID)
        .update({'profilURL': profilFotoURL});
    return true;
  }

  @override
  Future<List<UserModel>> getAllUser() async {
    try {
      // Firebase'den verileri alıyoruz.
      QuerySnapshot querySnapshot =
          await _firebaseDB.collection("userModels").get();

      // Debug için querySnapshot'taki dökümanları yazdıralım.
      print("Toplam döküman sayısı: ${querySnapshot.docs.length}");

      // Kullanıcı listesini tutmak için bir liste oluşturuyoruz.
      List<UserModel> userList = [];

      // Her bir kullanıcıyı döngüyle işliyoruz.
      for (DocumentSnapshot tekUser in querySnapshot.docs) {
        print("Okunan user: " + tekUser.data().toString());

        // Firebase'den alınan veriyi UserModel'e doğrudan dönüştürüyoruz.
        var userData = tekUser.data() as Map<String, dynamic>;

        // Veriyi constructor ile doğrudan UserModel'e aktarıyoruz.
        UserModel userModel = UserModel(
          userID: userData['userID'],
          email: userData['email'],
        );

        // Kullanıcıyı listeye ekliyoruz.
        userList.add(userModel);
      }

      // Eğer kullanıcı listesi boşsa, hata fırlatıyoruz.
      if (userList.isEmpty) {
        print("Kullanıcı bulunamadı.");
        throw Exception("Kullanıcı bulunamadı.");
      }

      // Debug console'da tüm kullanıcıları yazdıralım.
      print("Toplam Kullanıcı Sayısı: ${userList.length}");
      userList.forEach((user) {
        print("Kullanıcı ID: ${user.userID}, Kullanıcı email: ${user.email}");
      });

      // Sonuç olarak kullanıcı listesini döndürüyoruz.
      return userList;
    } catch (e) {
      // Hata mesajını yazdırıyoruz.
      print("Hata: $e");
      throw e; // Hata fırlatıyoruz.
    }
  }
}
