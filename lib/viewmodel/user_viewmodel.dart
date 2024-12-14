import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:net_chat/locator.dart';
import 'package:net_chat/model/user.dart';
import 'package:net_chat/repository/user_repository.dart';
import 'package:net_chat/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewmodel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _userModel;

  String? emailHataMesaji =
      null; // nullable null yapmak icin böyle yaptik yoksa string null olmuyo
  String? sifreHataMesaji = null; // nullable

  UserModel? get userModel => _userModel;

  get state => _state;

  set state(value) {
    _state = value;
    notifyListeners();
  }

  UserViewmodel() {
    currentUser();
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.currentUser();
      return _userModel;
    } catch (e) {
      debugPrint("ViewModel currentUser Hata: $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInAnonymously();
      return _userModel;
    } catch (e) {
      debugPrint("ViewModel currentUser Hata: $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _userModel = null;
      return sonuc;
    } catch (e) {
      debugPrint("ViewModel currentUser Hata: $e");
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    var tumKullaniciListesi = await _userRepository.getAllUser();
    return tumKullaniciListesi;
  }

  @override
  Future<UserModel?> singInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.singInWithGoogle();
      return _userModel;
    } catch (e) {
      debugPrint("ViewModel currentUser Hata: $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(
      String email, String password) async {
    if (_emailSifreKontrol(email, password)) {
      try {
        state = ViewState.Busy;
        _userModel =
            await _userRepository.createWithEmailAndPassword(email, password);
        return _userModel;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      if (_emailSifreKontrol(email, password)) {
        state = ViewState.Busy;
        _userModel =
            await _userRepository.signInWithEmailAndPassword(email, password);
        return _userModel;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String password) {
    // sifre yerine password olabilridi

    var sonuc = true;

    if (password.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalı";
      sonuc = false;
    } else {
      sifreHataMesaji = null;
    }
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz e-mail adresi";
      sonuc = false;
    } else {
      emailHataMesaji = null;
    }

    return sonuc;
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, yeniUserName);
    if (sonuc) {
      _userModel!.userName = yeniUserName;
    }
    return sonuc;
  }

  Future<String> uploadFile(
      String? userID, String fileType, XFile? profilFoto) async {
    // XFile'ı File'a dönüştür
    File? fileToUpload = profilFoto != null ? File(profilFoto.path) : null;

    var indirmeLinki = await _userRepository.uploadFile(
        userID, fileType, fileToUpload as XFile?);

    return indirmeLinki;
  } // Profildeki controller çalışmadığı için çalışmadı
}
