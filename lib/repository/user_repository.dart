import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:net_chat/locator.dart';
import 'package:net_chat/model/konusma.dart';
import 'package:net_chat/model/mesaj.dart';
import 'package:net_chat/model/user.dart';
import 'package:net_chat/services/auth_base.dart';
import 'package:net_chat/services/fake_auth_service.dart';
import 'package:net_chat/services/firebase_auth_service.dart';
import 'package:net_chat/services/firebase_storage_service.dart';
import 'package:net_chat/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FirestoreDbService _firestoreDbService = locator<FirestoreDbService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  List<UserModel> tumKullaniciListesi = [];

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel? _userModel = await _firebaseAuthService.currentUser();
      return await _firestoreDbService
          .readUser(_userModel!.userID); // Hata cikarsa buraya bakmak lazim
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> singInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.singInWithGoogle();
    } else {
      UserModel? _userModel = await _firebaseAuthService.singInWithGoogle();
      bool _sonuc = await _firestoreDbService
          .saveUser(_userModel!); // Hata cikarsa buraya bakmak lazim
      if (_sonuc) {
        return await _firestoreDbService.readUser(_userModel.userID);
      } else
        return null;
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createWithEmailAndPassword(email, password);
    } else {
      UserModel? _userModel = await _firebaseAuthService
          .createWithEmailAndPassword(email, password);
      bool _sonuc = await _firestoreDbService
          .saveUser(_userModel!); // Hata cikarsa buraya bakmak lazim
      if (_sonuc) {
        return await _firestoreDbService.readUser(_userModel.userID);
      } else
        return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailAndPassword(email, password);
    } else {
      UserModel? _userModel = await _firebaseAuthService
          .signInWithEmailAndPassword(email, password);
      return await _firestoreDbService.readUser(_userModel!.userID);
    }
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDbService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String> uploadFile(
      String? userID, String fileType, XFile? profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFile(
          userID ?? 'default', fileType, profilFoto as File);
      await _firestoreDbService.updateProfilFoto(userID, profilFotoURL);
      return profilFotoURL;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = await _firestoreDbService.getAllUser();
      return tumKullaniciListesi;
    }
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDbService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDbService.saveMessage(kaydedilecekMesaj);
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _firestoreDbService.saatiGoster(userID);

      var konusmaListesi =
          await _firestoreDbService.getAllConversations(userID);

      for (var oAnkiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedeUserBul(oAnkiKonusma.kimle_konusuyor);

        if (userListesindekiKullanici != null) {
          oAnkiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          // oAnkiKonusma.konusulanUserProfilURL = userListesindekiKullanici.profilURL;
          oAnkiKonusma.sonOkunmaZamani = _zaman;
          timeago.setLocaleMessages("tr", timeago.TrMessages());
          var _duration =
              _zaman.difference(oAnkiKonusma.olusturulma_tarihi.toDate());

          oAnkiKonusma.aradakiFark =
              timeago.format(_zaman.subtract(_duration), locale: "tr");
        } else {
          print(
              "Aranılan kullanıcı daha önceden veritabanına getirilmemiş, o yüzden veritabanından bu değeri okutmalıyız");
          var _veritabanindanOkunanUser =
              await _firestoreDbService.readUser(oAnkiKonusma.kimle_konusuyor);
          oAnkiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
          // oAnkiKonusma.konusulanUserProfilURL = _veritabanindanOkunanUser.profilURL;
        }

        timeAgoHesapla(oAnkiKonusma, _zaman);
      }
      return konusmaListesi;
    }
  }

  UserModel? listedeUserBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userID == userID) {
        return tumKullaniciListesi[i];
      }
    }

    return null;
  }
}

void timeAgoHesapla(Konusma oAnkiKonusma, DateTime zaman) {
  oAnkiKonusma.sonOkunmaZamani = zaman;
  var _duration = zaman.difference(oAnkiKonusma.olusturulma_tarihi.toDate());

  oAnkiKonusma.aradakiFark = timeago.format(zaman.subtract(_duration));
}
