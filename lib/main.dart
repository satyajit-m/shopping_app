import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/color_const.dart';
import 'package:shopping_app/src/app.dart';

import 'auth/auth_page.dart';
import 'auth/phone_auth.dart';

import 'src/forms/profile_form.dart';

class MyApp extends StatelessWidget {
  // MyApp() {
  //   //Navigation.initPaths();
  // }
  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: MaterialApp(
        theme: ThemeData(
          accentColor: Colors.blue,
          primaryColor: backText,
          iconTheme: IconThemeData(color: Colors.blue),
        ),
        //onGenerateRoute: Navigation.router.generator,
        debugShowCheckedModeBanner: false,
        routes: {
          // '/': (context) => Splash(),
          '/': (context) => AuthPage(),
          '/home': (context) => App(),
          '/phoneAuth': (context) => PhoneAuth(),
          '/profile/form': (context) => ProfileForm(),
          //'/profile/myOrders': (context) => MyOrders(FirebaseUser user),
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
