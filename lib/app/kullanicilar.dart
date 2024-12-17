import 'package:flutter/material.dart';
import 'package:net_chat/app/sign_in/sohbet_page.dart';
import 'package:net_chat/model/user.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  const KullanicilarPage({super.key});

  @override
  State<KullanicilarPage> createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  Future<List<UserModel>>? _tumKullanicilarFuture;

  @override
  void initState() {
    super.initState();
    _initializeUserList();
  }

  void _initializeUserList() {
    final _userViewModel = Provider.of<UserViewmodel>(context, listen: false);
    setState(() {
      _tumKullanicilarFuture = _userViewModel.getAllUser();
    });
  }

  void _refreshUserList() {
    setState(() {
      _initializeUserList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kullanıcılar",
          style: TextStyle(color: Color.fromARGB(255, 153, 139, 139)),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _refreshUserList();
            },
          ),
        ],
      ),
      body: _tumKullanicilarFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<UserModel>>(
              future: _tumKullanicilarFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var tumKullanicilar = snapshot.data;

                  if (tumKullanicilar!.isNotEmpty &&
                      tumKullanicilar.length >= 1) {
                    return ListView.builder(
                      itemCount: tumKullanicilar.length,
                      itemBuilder: (context, index) {
                        var oankiUser = tumKullanicilar[index];
                        if (oankiUser.userID !=
                            _userViewModel.userModel?.userID) {
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
                                    sohbetEdilenUser: oankiUser,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(oankiUser.userName),
                              subtitle: Text(oankiUser.email),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(oankiUser.profilURL ?? ''),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.supervised_user_circle,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            "Henüz Kullanıcı Yok",
                            style: TextStyle(fontSize: 36),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return const Center(child: Text("Bir hata oluştu."));
                }
              },
            ),
    );
  }
}
