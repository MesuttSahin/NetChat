import 'package:flutter/material.dart';
import 'package:net_chat/app/sign_in/email_sifre_kayit.dart';
import 'package:net_chat/common_widget/social_login_button.dart';
import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  void _misafirGirisi(BuildContext context) async {
    final userViewModel = Provider.of<UserViewmodel>(context, listen: false);

    try {
      UserModel? user = await userViewModel.signInAnonymously();
      if (user != null) {
        print("Kullanıcı id : ${user.userID}");
      } else {
        print("Kullanıcı girişi başarısız");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  void _googleIleGiris(BuildContext context) async {
    final userViewModel = Provider.of<UserViewmodel>(context, listen: false);

    try {
      UserModel? user = await userViewModel.singInWithGoogle();
      if (user != null) {
        print("Kullanıcı id : ${user.userID}");
      } else {
        print("Kullanıcı girişi başarısız");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  void _emailVeSifreGiris(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true, builder: (context) => const EmailSifreLoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70, // ana sayfa arka plan rengi
      appBar: AppBar(
        title: const Text("NetChat"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
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
                buttonIcon: const Icon(Icons.email),
                textColor: Colors.white,
                onPressed: () {
                  _emailVeSifreGiris(context);
                }),
            SocialLoginButton(
                buttonText: "Misafir Girişi",
                buttonColor: Colors.black,
                buttonIcon: const Icon(Icons.email),
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
