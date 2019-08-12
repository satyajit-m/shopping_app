import 'package:flutter/material.dart';
import 'auth/auth_page.dart';
import 'package:shopping_app/src/app.dart';

class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp Title',
      theme: ThemeData(
        accentColor: Colors.pinkAccent,
      ),
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => App(),
        '/home': (context) => AuthPage(),
      },
    );
  }
}

void main() {
  runApp(MyApp());
}
