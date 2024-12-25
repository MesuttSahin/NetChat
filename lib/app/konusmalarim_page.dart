import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:net_chat/app/sign_in/sohbet_page.dart';
import 'package:net_chat/model/konusma.dart';
import 'package:net_chat/model/user.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  const KonusmalarimPage({super.key});

  @override
  State<KonusmalarimPage> createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    UserViewmodel _userViewModel = Provider.of<UserViewmodel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Konuşmalarım"),
        ),
        body: FutureBuilder<List<Konusma>>(
            future: _userViewModel
                .getAllConversations(_userViewModel.userModel!.userID),
            builder: (context, konusmaListesi) {
              if (!konusmaListesi.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                var tumKonusmalar = konusmaListesi.data;
                if (tumKonusmalar!.length > 0) // buraya dikkat et
                {
                  return RefreshIndicator(
                    onRefresh: _konusmalarimListesiniYenile,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var oAnkiKonusma = tumKonusmalar[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => SohbetPage(
                                  currentUser: _userViewModel.userModel ??
                                      UserModel(
                                          userID: '',
                                          email: 'Varsayılan Email',
                                          userName: ''),
                                  sohbetEdilenUser: UserModel.idveResim(
                                      userID: oAnkiKonusma.kimle_konusuyor,
                                      profilURL:
                                          oAnkiKonusma.konusulanUserProfilURL),
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                                oAnkiKonusma.konusulanUserName ??
                                    "Kullanıcı Adı Bulunamadı",
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            subtitle: Text(oAnkiKonusma.son_yollanan_mesaj +
                                "      " +
                                oAnkiKonusma.aradakiFark.toString()),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(oAnkiKonusma
                                      .konusulanUserProfilURL ??
                                  "https://images.unsplash.com/photo-1733235014900-380902922aa2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyN3x8fGVufDB8fHx8fA%3D%3D"),
                            ),
                          ),
                        );
                      },
                      itemCount: tumKonusmalar.length,
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: _konusmalarimListesiniYenile,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.message,
                                color: Theme.of(context).primaryColor,
                                size: 120,
                              ),
                              Text(
                                "Henüz Mesaj Yok",
                                style: TextStyle(fontSize: 36),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            }));
  }

  void _konusmalarimiGetir() async {
    final _userModel = Provider.of<UserViewmodel>(context);
    var konusmalarim = await FirebaseFirestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.userModel?.userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    for (var konusma in konusmalarim.docs) {
      print("Konuşmalar : " + konusma.data().toString());
    }
  }

  Future<Null> _konusmalarimListesiniYenile() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {});

    return null;
  }
}
