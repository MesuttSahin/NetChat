import 'package:flutter/material.dart';
import 'package:net_chat/app/sign_in/email_sifre_kayit.dart';
import 'package:net_chat/common_widget/social_login_button.dart';
import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  void _misafirGirisi(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewmodel>(context, listen: false);

    try {
      UserModel? _user = await _userViewModel.signInAnonymously();
      if (_user != null) {
        print("Kullanıcı id : ${_user.userID}");
      } else {
        print("Kullanıcı girişi başarısız");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  void _googleIleGiris(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewmodel>(context, listen: false);

    try {
      UserModel? _user = await _userViewModel.singInWithGoogle();
      if (_user != null) {
        print("Kullanıcı id : ${_user.userID}");
      } else {
        print("Kullanıcı girişi başarısız");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  void _emailVeSifreGiris(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true, builder: (context) => EmailSifreLoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70, // ana sayfa arka plan rengi
      appBar: AppBar(
        title: Text("NetChat"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Oturum Aç",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            SocialLoginButton(
                buttonText: "Gmail ile Giriş Yap",
                buttonColor: Colors.white,
                buttonIcon: Image.asset("images/gmail-logo.png"),
                textColor: Colors.black87,
                onPressed: () {
                  _googleIleGiris(context);
                }),
            SocialLoginButton(
                buttonText: "Facebook İle Giriş Yap",
                buttonIcon: Image.asset("images/facebook-logo.png"),
                buttonColor: const Color(0xFF334D92),
                textColor: Colors.white,
                onPressed: () {}),
            SocialLoginButton(
                buttonText: "E-mail ile Giriş Yap",
                buttonColor: Colors.purple.shade400,
                buttonIcon: Icon(Icons.email),
                textColor: Colors.white,
                onPressed: () {
                  _emailVeSifreGiris(context);
                }),
            SocialLoginButton(
                buttonText: "Misafir Girişi",
                buttonColor: Colors.black,
                buttonIcon: Icon(Icons.email),
                textColor: Colors.white,
                onPressed: () {
                  _misafirGirisi(context);
                }),
          ],
        ),
      ),
    );
  }
}
