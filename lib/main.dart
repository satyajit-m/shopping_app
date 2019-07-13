import 'package:flutter/material.dart';
import 'package:shopping_app/auth/util/state_widget.dart';
import 'package:shopping_app/auth/ui/theme.dart';
import 'package:shopping_app/auth/ui/screens/home.dart';
import 'package:shopping_app/auth/ui/screens/sign_in.dart';
import 'package:shopping_app/auth/ui/screens/sign_up.dart';
import 'package:shopping_app/auth/ui/screens/forgot_password.dart';
import 'package:shopping_app/src/app.dart';

import 'auth/login_screen3.dart';

class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp Title',
      theme: buildTheme(),
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginScreen3(),
        '/home': (context) => App(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
}
