import 'package:flutter/material.dart';
import 'package:shopping_app/src/app.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth/auth_page.dart';

import 'src/forms/profile_form.dart';

class MyApp extends StatelessWidget {
  // MyApp() {
  //   //Navigation.initPaths();
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.blueAccent,
      ),
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => AuthPage(),
        '/home': (context) => App(),
        '/profile/form': (context) => ProfileForm(),
      },
    );
  }
}

void main() {
  runApp(MyApp());
}
