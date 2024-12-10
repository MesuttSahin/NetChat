import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:net_chat/app/landing_page.dart';
import 'package:net_chat/locator.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  setUpLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlatıyoruz

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewmodel(),
      child: MaterialApp(
          title: "NetChat",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const LandingPage()),
    );
  }
}
