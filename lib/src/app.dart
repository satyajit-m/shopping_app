/*
add badge when backend is implemented
https://stackoverflow.com/questions/45155104/displaying-notification-badge-on-bottomnavigationbars-icon
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/screens/MyOrders/myorders.dart';

import 'screens/home.dart';
import 'screens/help.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

import 'screens/profile.dart';

class App extends StatefulWidget {
  AppState createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  FirebaseUser user;
  var dataLoaded = false;
  AppState() {
    getUser();
  }
  int currentTab = 0;
  List<Widget> screens;
  Widget currentScreen = HomeScreen();
  final PageStorageBucket bucket = PageStorageBucket();

  Widget build(BuildContext context) {
    if (!dataLoaded) {
      return SafeArea(
        child: Scaffold(
          extendBody: true,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
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
            bmnav.BottomNavItem(Icons.location_on, label: 'Location'),
            bmnav.BottomNavItem(Icons.person, label: 'profile'),
          ],
          iconStyle: bmnav.IconStyle(onSelectSize: 30.0),
        ),
      ),
    );
  }

  void getUser() async {
    print("tryin to get Current User");
    user = await FirebaseAuth.instance.currentUser();
    screens = [
      HomeScreen(),
      HelpScreen(),
      ProfileScreen(),
      // Tester(
      //   user: user,
      // )
    ];
    setState(() {
      dataLoaded = true;
    });
  }
}
