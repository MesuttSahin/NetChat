import 'package:flutter/material.dart';

class KullanicilarPage extends StatelessWidget {
  const KullanicilarPage({super.key});

  @override
  Widget build(BuildContext context) {
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
