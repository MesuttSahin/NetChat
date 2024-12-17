import 'package:cloud_firestore/cloud_firestore.dart';

class Konusma {
  final String konusma_sahibi;
  final String kimle_konusuyor;
  final bool goruldu;
  final Timestamp olusturulma_tarihi;
  final String son_yollanan_mesaj;
  final Timestamp gorulme_tarihi;
  String? konusulanUserName;
  String? konusulanUserProfilURL;
  DateTime? sonOkunmaZamani;
  String? aradakiFark;

  Konusma(
      {required this.konusma_sahibi,
      required this.kimle_konusuyor,
      required this.goruldu,
      required this.olusturulma_tarihi,
      required this.son_yollanan_mesaj,
      required this.gorulme_tarihi});

  Map<String, dynamic> toMap() {
    return {
      'konusma_sahibi': konusma_sahibi,
      'kimle_konusuyor': kimle_konusuyor,
      'goruldu': goruldu,
      'olusturulma_tarihi': olusturulma_tarihi,
      'son_yollanan_mesaj': son_yollanan_mesaj,
      'gorulme_tarihi': gorulme_tarihi
    };
  }

  Konusma.fromMap(Map<String, dynamic> map)
      : konusma_sahibi = map['konusma_sahibi'] ?? '',
        kimle_konusuyor = map['kimle_konusuyor'] ?? '',
        goruldu = map['goruldu'] ?? false, // Varsayılan false ekledik
        olusturulma_tarihi = map['olusturulma_tarihi'] ?? Timestamp.now(),
        son_yollanan_mesaj = map['son_yollanan_mesaj'] ?? '',
        gorulme_tarihi = map['gorulme_tarihi'] ?? Timestamp.now();

  @override
  String toString() {
    return 'Konusma{konusma_sahibi: $konusma_sahibi, '
        'kimle_konusuyor: $kimle_konusuyor, '
        'goruldu: $goruldu, '
        'olusturulma_tarihi: $olusturulma_tarihi, '
        'son_yollanan_mesaj: $son_yollanan_mesaj, '
        'gorulme_tarihi: $gorulme_tarihi}';
  }
}
