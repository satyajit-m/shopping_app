import 'package:flutter/material.dart';
import 'auth/auth_page.dart';
import 'package:shopping_app/src/app.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {

  final FirebaseUser user;

  MyApp(this.user);

  // MyApp() {
  //   //Navigation.initPaths();
  // }
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
        '/home': (context) => user == null ? AuthPage() : App(),
      },
    );
  }
}

void main() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  runApp(MyApp(user));
}
