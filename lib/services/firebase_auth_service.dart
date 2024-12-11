import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:net_chat/model/user.dart';
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
    return UserModel(userID: user.uid,email: user.email!); // buraya dikkat et null olamaz dedim çünkü
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
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
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
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.idToken != null && googleAuth.accessToken != null) {
          final OAuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
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

      UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userModelFromFirebase(sonuc.user);
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userModelFromFirebase(sonuc.user);
    } catch (e) {
      print("firebase auth servise oturum acma hata" + e.toString());
      return null;
    }
  }
}
