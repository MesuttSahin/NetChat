import 'package:flutter/material.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
  const KullanicilarPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewmodel _userViewModel =
        Provider.of<UserViewmodel>(context, listen: false);
    _userViewModel.getAllUser();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kullanıcılar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text("Kullanıcılar Sayfası"),
      ),
    );
  }
}
