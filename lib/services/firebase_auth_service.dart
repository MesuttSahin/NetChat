import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // currentUser() metodu doğru şekilde Firebase kullanıcıyı alacak şekilde güncellenmiştir.
  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser; // await kullanımı eklendi
      return _userModelFromFirebase(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Firebase User'dan UserModel'e dönüşüm yapacak metod
  UserModel? _userModelFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(userID: user.uid);
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      return _userModelFromFirebase(sonuc.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  @override
  Future<UserModel?> singInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

      if (_googleUser != null) {
        final GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;

        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          final OAuthCredential credential = GoogleAuthProvider.credential(
            idToken: _googleAuth.idToken,
            accessToken: _googleAuth.accessToken,
          );

          final UserCredential sonuc =
              await _firebaseAuth.signInWithCredential(credential);

          return _userModelFromFirebase(sonuc.user);
        } else {
          throw FirebaseAuthException(
            code: "MISSING_GOOGLE_AUTH_TOKEN",
            message: "Google auth token bulunamadı.",
          );
        }
      } else {
        throw FirebaseAuthException(
          code: "GOOGLE_SIGN_IN_CANCELED",
          message: "Google giriş işlemi iptal edildi.",
        );
      }
    } catch (e) {
      debugPrint("Google Sign-In Hatası: $e");
      return null;
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userModelFromFirebase(sonuc.user);
    } catch (e) {
      print("firebase hatası: " + e.toString());
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userModelFromFirebase(sonuc.user);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
