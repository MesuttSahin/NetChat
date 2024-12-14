import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:net_chat/locator.dart';
import 'package:net_chat/model/user.dart';
import 'package:net_chat/services/auth_base.dart';
import 'package:net_chat/services/fake_auth_service.dart';
import 'package:net_chat/services/firebase_auth_service.dart';
import 'package:net_chat/services/firebase_storage_service.dart';
import 'package:net_chat/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FirestoreDbService _firestoreDbService = locator<FirestoreDbService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

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
      var tumKullaniciListesi = await _firestoreDbService.getAllUser();
      return tumKullaniciListesi;
    }
  }
}
