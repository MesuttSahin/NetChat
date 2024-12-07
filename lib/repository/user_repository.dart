import 'package:net_chat/locator.dart';
import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/services/auth_base.dart';
import 'package:net_chat/services/fake_auth_service.dart';
import 'package:net_chat/services/firebase_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
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
      return await _firebaseAuthService.singInWithGoogle();
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createWithEmailAndPassword(email, password);
    } else {
      return await _firebaseAuthService.createWithEmailAndPassword(
          email, password);
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailAndPassword(email, password);
    } else {
      return await _firebaseAuthService.signInWithEmailAndPassword(
          email, password);
    }
  }
}
