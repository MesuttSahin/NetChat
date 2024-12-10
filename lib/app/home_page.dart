import 'package:flutter/material.dart';
import 'package:net_chat/app/kullanicilar.dart';
import 'package:net_chat/app/my_custom_buttom_nav.dart';
import 'package:net_chat/app/profil.dart';
import 'package:net_chat/app/tab_items.dart';
import 'package:net_chat/model/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user, required userModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: KullanicilarPage(),
      TabItem.Profil: ProfilPage()
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyCustomButtomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          setState(() {
            _currentTab = secilenTab;
          });

          print("Seçilen Tab İtem" + secilenTab.toString());
        },
      ),
    );
  }

  // Future<bool> _cikisYap(BuildContext context) async {
  //   final userViewModel = Provider.of<UserViewmodel>(context, listen: false);
  //   var sonuc = await userViewModel.signOut();
  //   return sonuc;
  // }
}
