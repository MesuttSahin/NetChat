import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:net_chat/model/mesaj.dart';
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
      QuerySnapshot querySnapshot =
          await _firebaseDB.collection("userModels").get();
      print("Toplam döküman sayısı: ${querySnapshot.docs.length}");
      List<UserModel> tumKullanicilar = [];
      for (DocumentSnapshot tekUser in querySnapshot.docs) {
        // UserModel _tekUser =
        //     UserModel.fromMap(tekUser.data() as Map<String, dynamic>);
        var userData = tekUser.data() as Map<String, dynamic>;
        // Veriyi constructor ile doğrudan UserModel'e aktarıyoruz.
        UserModel userModel = UserModel(
            userID: userData['userID'],
            email: userData['email'],
            userName: userData['userName']);

        // Kullanıcıyı listeye ekliyoruz.
        tumKullanicilar.add(userModel);
      }

      // Eğer kullanıcı listesi boşsa, hata fırlatıyoruz.
      if (tumKullanicilar.isEmpty) {
        print("Kullanıcı bulunamadı.");
        throw Exception("Kullanıcı bulunamadı.");
      }

      // Debug console'da tüm kullanıcıları yazdıralım.
      print("Toplam Kullanıcı Sayısı: ${tumKullanicilar.length}");
      tumKullanicilar.forEach((user) {
        print("Kullanıcı ID: ${user.userID}, Kullanıcı email: ${user.email}");
      });

      /*tumKullanicilar = querySnapshot.docs
          .map((tekSatir) =>
              UserModel.fromMap(tekSatir.data() as Map<String, dynamic>))
          .toList();
      // Sonuç olarak kullanıcı listesini döndürüyoruz.*/

      return tumKullanicilar;
    } catch (e) {
      // Hata mesajını yazdırıyoruz.
      print("Hata: $e");
      throw e; // Hata fırlatıyoruz.
    }
  }

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    var snapShot = _firebaseDB
        .collection("konusmalar")
        .doc(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .orderBy("date",descending: true)
        .snapshots();
    return snapShot.map((mesajListesi) =>
        mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firebaseDB.collection("konusmalar").doc().id;
    var _myDocumentID =
        kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID =
        kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;
    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();

    await _firebaseDB
        .collection("konusmalar")
        .doc(_myDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajMapYapisi);
    _kaydedilecekMesajMapYapisi.update("bendenMi", (deger) => false);

    await _firebaseDB
        .collection("konusmalar")
        .doc(_receiverDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajMapYapisi);

    return true;
  }
}
