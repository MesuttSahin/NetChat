import 'package:flutter/material.dart';
import 'package:net_chat/common_widget/social_login_button.dart';
import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

enum FormType { REGISTER, LOGIN }

class EmailSifreLoginPage extends StatefulWidget {
  const EmailSifreLoginPage({super.key});

  @override
  State<EmailSifreLoginPage> createState() => _EmailSifreLoginPageState();
}

class _EmailSifreLoginPageState extends State<EmailSifreLoginPage> {
  String? _email, _password;
  String? buttonText, linkText;
  var _formType = FormType.LOGIN;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final _userModel = Provider.of<UserViewmodel>(context, listen: false);
      if (_email != null && _password != null) {
        print('Email: $_email, Password: $_password');

        if (_formType == FormType.LOGIN) {
          UserModel? _girisYapanUser =
              await _userModel.signInWithEmailAndPassword(_email!, _password!);
          if (_girisYapanUser != null) {
            print("Oturum açan user : " + _girisYapanUser.userID.toString());
          }
        }
      } else {
        UserModel? _olusturulanUser =
            await _userModel.createWithEmailAndPassword(_email!, _password!);
        if (_olusturulanUser != null) {
          print("Oturum açan user : " + _olusturulanUser.userID.toString());
        }
      }
    } else {
      print('Form hatalı');
    }
  }

  void degistir() {
    setState(() {
      _formType =
          _formType == FormType.LOGIN ? FormType.REGISTER : FormType.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    buttonText = _formType == FormType.LOGIN ? 'Giriş Yap' : 'Kayıt Ol';
    linkText = _formType == FormType.LOGIN
        ? 'Hesabınız Yok Mu? Kayıt Olun'
        : 'Hesabınız Var Mı? Giriş Yapın';

    return Scaffold(
        appBar: AppBar(
          title: const Text('Giriş / Kayıt'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: "Email",
                          label: Text("Email"),
                          border: OutlineInputBorder()),
                      onSaved: (String? inputMail) {
                        _email = inputMail;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "Password",
                          label: Text("Password"),
                          border: OutlineInputBorder()),
                      onSaved: (String? inputPassword) {
                        _password = inputPassword;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SocialLoginButton(
                        buttonText: buttonText!,
                        buttonColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _formSubmit();
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          degistir();
                        },
                        child: Text(linkText!))
                  ],
                )),
          ),
        ));
  }
}
