/*
add badge when backend is implemented
https://stackoverflow.com/questions/45155104/displaying-notification-badge-on-bottomnavigationbars-icon
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/help.dart';

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
        appBar: AppBar(
          title: Text('Shopping'),
        ),
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        bottomNavigationBar: BottomNavyBar(
          currentIndex: currentTab,
          onItemSelected: (index) => setState(() {
                currentTab = index;
                currentScreen = screens[currentTab];
              }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.help),
              title: Text('Help'),
              activeColor: Colors.purpleAccent),
            BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text('Account'),
              activeColor: Colors.greenAccent),
          ],
        ),
      ),
    );
  }
}
