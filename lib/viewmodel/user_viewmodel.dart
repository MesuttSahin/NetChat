import 'package:flutter/material.dart';
import 'package:net_chat/locator.dart';
import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/repository/user_repository.dart';
import 'package:net_chat/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewmodel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  UserModel? _userModel;

  UserModel? get userModel => this._userModel;

  get state => this._state;

  set state(value) {
    this._state = value;
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
      debugPrint("ViewModel currentUser Hata: " + e.toString());
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
      debugPrint("ViewModel currentUser Hata: " + e.toString());
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
      debugPrint("ViewModel currentUser Hata: " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> singInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.singInWithGoogle();
      return _userModel;
    } catch (e) {
      debugPrint("ViewModel currentUser Hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(
      String email, String password) async {
    try {
      state = ViewState.Busy;
      _userModel =
          await _userRepository.createWithEmailAndPassword(email, password);
      return _userModel;
    } catch (e) {
      debugPrint("ViewModel currentUser Hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      state = ViewState.Busy;
      _userModel =
          await _userRepository.signInWithEmailAndPassword(email, password);
      return _userModel;
    } catch (e) {
      debugPrint("ViewModel currentUser Hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }
}
