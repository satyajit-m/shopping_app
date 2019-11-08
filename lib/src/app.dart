/*
add badge when backend is implemented
https://stackoverflow.com/questions/45155104/displaying-notification-badge-on-bottomnavigationbars-icon
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/screens/help.dart';

import 'screens/home.dart';

import 'screens/profile.dart';

class App extends StatefulWidget {
  AppState createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  FirebaseUser user;

  void initState() {
    getUser();
    super.initState();
  }

  List<Widget> screens = [
    HomeScreen(key: PageStorageKey("HomeScreen")),
    //Locations(key: PageStorageKey("Locations")),
    HelpScreen(key: PageStorageKey("HelpScreen")),
    ProfileScreen(key: PageStorageKey("ProfileScreen")),
  ];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  int bottomNavBarIndex = 0;
  int pageControllerIndex = 0;

  void pageChanged(int index) {
    setState(() {
      bottomNavBarIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      pageControllerIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) => pageChanged(index),
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          showUnselectedLabels: true,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.orange[200],
          type: BottomNavigationBarType.fixed,
          unselectedIconTheme: IconThemeData(
            color: Colors.orange[200],
            opacity: 1.0,
          ),
          selectedIconTheme: IconThemeData(
            color: Colors.deepOrange,
            opacity: 1.0,
          ),
          onTap: (index) => bottomTapped(index),
          currentIndex: bottomNavBarIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            //BottomNavigationBarItem(icon: Icon(Icons.location_on), title: Text('Locations')),
            BottomNavigationBarItem(icon: Icon(Icons.help), title: Text('Help')),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile'))
          ],
        ),
      ),
    );
  }

  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }
}
