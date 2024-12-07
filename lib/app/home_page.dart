import 'package:flutter/material.dart';
import 'package:net_chat/model/user_model.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          TextButton(
            onPressed: () {
              _cikisYap(context);
            },
            child: const Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Center(
        // `_user?.uid` ile null güvenli erişim sağlandı.
        child: Text(user.userID),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final userViewModel = Provider.of<UserViewmodel>(context, listen: false);
    var sonuc = await userViewModel.signOut();
    return sonuc;
  }
}
