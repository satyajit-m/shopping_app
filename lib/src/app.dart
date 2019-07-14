/*
add badge when backend is implemented
https://stackoverflow.com/questions/45155104/displaying-notification-badge-on-bottomnavigationbars-icon
*/

import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/help.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

class App extends StatefulWidget {
//  FirebaseUser user;
//  App(this.user);

  AppState createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeScreen(),
    HelpScreen(),
    ProfileScreen(),
  ];
  Widget currentScreen = HomeScreen();
  final PageStorageBucket bucket = PageStorageBucket();

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      home: Scaffold(
        
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        bottomNavigationBar: bmnav.BottomNav(
          onTap: (index) {
            setState(() {
              currentTab = index;
              currentScreen = screens[index];
            });
          },
          items: [
            bmnav.BottomNavItem(Icons.home, label: 'Home'),
            bmnav.BottomNavItem(Icons.help, label: 'Help'),
            bmnav.BottomNavItem(Icons.person, label: 'profile'),
          ],
          iconStyle: bmnav.IconStyle(onSelectSize: 30.0),
        ),
      ),
    );
  }
}
