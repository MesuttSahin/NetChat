import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:net_chat/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:net_chat/common_widget/social_login_button.dart';
import 'package:net_chat/model/user.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController? _controllerUserName;
  XFile? _profilFoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName?.dispose(); // Bellek sızıntısını önlemek için
    super.dispose();
  }

  void _kameradanFotoCek() async {
    var _yeniResim = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      Navigator.of(context).pop();
      _profilFoto = _yeniResim;
    });
  }

  void _galeridenResimSec() async {
    var _yeniResim = await _picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    setState(() {
      _profilFoto = _yeniResim;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewmodel _userViewModel =
        Provider.of<UserViewmodel>(context, listen: false);
    _controllerUserName?.text = _userViewModel.userModel?.userName ??
        ""; //A value of type 'String?' hatası
    print("Profil sayfasındaki user degerleri : " +
        _userViewModel.userModel.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profil",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            TextButton(
                onPressed: () => _cikisIcinOnayIste(context),
                child: Text(
                  "Çıkış",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            child: Column(children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text("Kameradan Çek"),
                                onTap: () {
                                  _kameradanFotoCek();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text("Galeriden Seç"),
                                onTap: () {
                                  _galeridenResimSec();
                                },
                              )
                            ]),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: _profilFoto == null
                        ? NetworkImage(_userViewModel.userModel?.profilURL ??
                            "https://images.unsplash.com/photo-1734000403535-49ae720a58a6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyMnx8fGVufDB8fHx8fA%3D%3D")
                        : FileImage(File(_profilFoto!.path)),
                    //Burda kırmızı null değer döndermez hatası alıyorum
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userViewModel.userModel?.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName, //Yukardaki text hatası için
                  decoration: InputDecoration(
                    labelText: "UserName",
                    hintText: "UserName",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                    buttonText: "Değişiklikleri Kaydet",
                    buttonColor: Colors
                        .purple, //Bu color ve textcolor required olduğu için ekledim
                    textColor: Colors.white,
                    onPressed: () {
                      _userNameGuncelle(context);
                      //_profilFotoGuncelle(context);
                    }),
              )
            ]),
          ),
        ));
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final userViewModel = Provider.of<UserViewmodel>(context, listen: false);
    var sonuc = await userViewModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewmodel>(context, listen: false);
    if (_userViewModel.userModel?.userName != _controllerUserName?.text) {
      var updateResult = await _userViewModel.updateUserName(
          _userViewModel.userModel!.userID,
          _controllerUserName!.text); //username kontrolü

      if (updateResult == true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "UserName değişikliği yapıldı",
          anaButonYazisi: "Tamam",
          iptalButonYazisi: "Iptal", //required olduğu için yazdım
        ).goster(context);
      } else {
        _controllerUserName!.text = _userViewModel.userModel!.userName!;
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "UserName zaten kullanımda farklı bir UserName deneyiniz",
          anaButonYazisi: "Tamam",
          iptalButonYazisi: "Iptal", //required olduğu için yazdım
        ).goster(context);
      }
    }
  }

  void _profilFotoGuncelle() async {
    final _userViewModel = Provider.of<UserViewmodel>(context); //++++++++++
    if (_profilFoto != null) {
      // _profilFoto'yu farklı bir şekilde dönüştür
      final XFile? convertedFile = XFile(_profilFoto!.path);

      var url = await _userViewModel.uploadFile(
          _userViewModel.userModel?.userID, "profil_foto", convertedFile);
      print("gelen url : " + url);

      if (url != null) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Profil fotoğrafınız güncellendi",
          anaButonYazisi: "Tamam",
          iptalButonYazisi: "Iptal",
        ).goster(context);
      }
    }
  }
}
