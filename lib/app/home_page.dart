import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:net_chat/app/konusmalarim_page.dart';
import 'package:net_chat/app/kullanicilar.dart';
import 'package:net_chat/app/my_custom_buttom_nav.dart';
import 'package:net_chat/app/profil.dart';
import 'package:net_chat/app/tab_items.dart';
import 'package:net_chat/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:net_chat/model/user.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({Key? key, required this.user, required userModel}) : super(key: key);  // userModel parametresini kaldırdım, çünkü zaten widget.user üzerinden erişebiliyoruz.

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  TabItem _currentTab = TabItem.Kullanicilar;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.subscribeToTopic("spor"); // Topic'e abone olunuyor.
    _initializeFirebaseMessaging();
  }

  /// Firebase Messaging initialization
  void _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // FCM token alınıp Firestore'a kaydediliyor.
    String? token = await messaging.getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.userID) // Kullanıcı ID'sine göre düzeltilen alan
          .update({'fcm_token': token});
    }

    // FCM izin kontrolü (iOS için)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission status: ${settings.authorizationStatus}');

    // Ön plandaki mesajları dinleme
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in foreground: ${message.notification?.title}');
      print('Message body: ${message.notification?.body}');

      // Burada gelen bildirimi UI üzerinde göstermek için gerekli işlemleri yapabilirsiniz.
      PlatformDuyarliAlertDialog(
        baslik: message.data['title'] ?? "Başlık yok",
        icerik: message.data['message'] ?? "İçerik yok",
        anaButonYazisi: "Tamam",
        iptalButonYazisi: 'İptal',
      ).goster(context);
    });

    // Mesaja tıklanarak uygulama açıldığında yapılacak işlemler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => KonusmalarimPage()), // Mesajlar sayfasına yönlendir
      );
    });

    // Uygulama kapalıyken gelen mesajlar (background state)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Firebase Messaging background handler
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Background message received: ${message.notification?.title}');
    // Arka planda gelen mesajlar burada işlenebilir.
  }

  /// Sayfaların oluşturulması
  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: KullanicilarPage(),
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          await navigatorKeys[_currentTab]?.currentState?.maybePop() ?? false,
      child: MyCustomButtomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]?.currentState?.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
