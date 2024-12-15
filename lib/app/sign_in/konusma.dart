import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:net_chat/model/mesaj.dart';
import 'package:net_chat/model/user.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class Konusma extends StatefulWidget {
  final UserModel currentUser;
  final UserModel sohbetEdilenUser;

  const Konusma(
      {super.key, required this.currentUser, required this.sohbetEdilenUser});

  @override
  State<Konusma> createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    UserModel _currentUser = widget.currentUser;
    UserModel _sohbetEdilenUser = widget.sohbetEdilenUser;
    final _userViewModel = Provider.of<UserViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Mesaj>>(
                  stream: _userViewModel.getMessages(
                      _currentUser.userID, _sohbetEdilenUser.userID),
                  builder: (context, streamMesajlarListesi) {
                    if (!streamMesajlarListesi.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var tumMesajlar = streamMesajlarListesi.data;
                    return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return _konusmaBalonuOlustur(tumMesajlar![index]);
                        },
                        itemCount: tumMesajlar?.length);
                  }),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: _mesajController,
                        cursorColor: Colors.blueGrey,
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Mesajınızı yazın",
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_mesajController.text.trim().length > 0) {
                          Mesaj _kaydedilecekMesaj = Mesaj(
                            kimden: _currentUser.userID,
                            kime: _sohbetEdilenUser.userID,
                            bendenMi: true,
                            mesaj: _mesajController.text,
                            date: null,
                          );
                          var sonuc = await _userViewModel
                              .saveMessage(_kaydedilecekMesaj);
                          if (sonuc) {
                            _mesajController.clear();
                            _scrollController.animateTo(
                              0.0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 10),
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;

    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("Hata var " + e.toString());
    }
    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Diğer parametreleri önce yazın
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.sohbetEdilenUser.profilURL ?? ''),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),
                ),
                Text(_saatDakikaDegeri)
              ],
            ),
          ],
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp? date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date!.toDate());
    return _formatlanmisTarih;
  }
}
