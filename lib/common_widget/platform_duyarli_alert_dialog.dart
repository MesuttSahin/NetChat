import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net_chat/common_widget/platform_duyarli_widget.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  final String baslik;
  final String icerik;
  final String anaButonYazisi;
  final String iptalButonYazisi;

  PlatformDuyarliAlertDialog({
    required this.baslik,
    required this.icerik,
    required this.anaButonYazisi,
    required this.iptalButonYazisi, // 'required' eklendi
  });

  Future<bool> goster(BuildContext context) async {
    return Platform.isAndroid
        ? await showCupertinoDialog<bool>(
                context: context, builder: (context) => this) ??
            false // Eğer null dönerse false ata
        : await showDialog<bool>(
                context: context,
                builder: (context) => this,
                barrierDismissible: false) ??
            false; // Eğer null dönerse false ata
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  List<Widget> _dialogButonlariniAyarla(BuildContext context) {
    final tumButonlar = <Widget>[];

    if (Platform.isAndroid) {
      tumButonlar.add(
        CupertinoDialogAction(
          child: Text(iptalButonYazisi),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      );
    
      tumButonlar.add(
        CupertinoDialogAction(
          child: Text(anaButonYazisi),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      tumButonlar.add(
        TextButton(
          child: Text(iptalButonYazisi),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      );
    
      tumButonlar.add(
        TextButton(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    return tumButonlar;
  }
}
