import 'package:flutter/material.dart';
import 'package:shopping_app/auth/otp_page.dart';
import 'package:shopping_app/src/app.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth/auth_page.dart';
import 'auth/phone_auth.dart';
import 'src/screens/MyOrders/myorders.dart';

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
        '/phoneAuth': (context) => PhoneAuth(),
        '/profile/form': (context) => ProfileForm(),
        '/profile/myOrders': (context) => MyOrders(),
      },
    );
  }
}

void main() {
  runApp(MyApp());
}
