import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net_chat/app/tab_items.dart';

class MyCustomButtomNavigation extends StatelessWidget {
  const MyCustomButtomNavigation(
      {super.key,
      required this.currentTab,
      required this.onSelectedTab,
      required this.sayfaOlusturucu});

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _navItemOlustur(TabItem.Kullanicilar),
          _navItemOlustur(TabItem.Profil),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final gosterilecekItem = TabItem.values[index];
        return CupertinoTabView(builder: (context) {
          return sayfaOlusturucu[gosterilecekItem] ??
              Center(
                child: Text("404 NOT FOUND"),
              );
        });
      },
    );
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final currentTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(currentTab!.icon),
      label: currentTab.title,
    );
  }
}
