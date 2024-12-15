import 'package:flutter/material.dart';
import 'package:net_chat/app/sign_in/konusma.dart';
import 'package:net_chat/model/user.dart';
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
      body: FutureBuilder<List<UserModel>>(
          future: _userViewModel.getAllUser(),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              var tumKullancililar = sonuc.data;

              if (tumKullancililar!.isNotEmpty) {
                return ListView.builder(
                  itemCount: tumKullancililar.length,
                  itemBuilder: (context, index) {
                    var oankiUser = sonuc.data?[index];
                    if (oankiUser?.userID != _userViewModel.userModel?.userID) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) => Konusma(
                              currentUser: _userViewModel.userModel ??
                                  UserModel(
                                      userID: '',
                                      email: 'Varsayılan Email',
                                      userName: ''),
                              sohbetEdilenUser: oankiUser ??
                                  UserModel(
                                      userID: '',
                                      email: 'Varsayılan Email',
                                      userName: ''),
                            ),
                          ));
                        },
                        child: ListTile(
                          title: Text(
                              oankiUser?.userName ?? 'Varsayilan Kullanici'),
                          subtitle: Text(oankiUser?.email ?? ''),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(oankiUser?.profilURL ?? ''),
                          ),
                        ),
                      );
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text("Kayıtlı kullanıcı yok"),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
/*builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) { 
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else{
            return Center(child: Text("Hata Olultu"));
          }
         },*/
