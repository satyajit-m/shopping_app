<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:shopping_app/auth/util/state_widget.dart';
import 'package:shopping_app/auth/ui/theme.dart';
import 'package:shopping_app/auth/ui/screens/sign_in.dart';
import 'package:shopping_app/auth/ui/screens/sign_up.dart';
import 'package:shopping_app/auth/ui/screens/forgot_password.dart';
import 'package:shopping_app/src/app.dart';

import 'auth/phone_auth.dart';

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
        '/': (context) => App(),
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
=======
import 'package:flutter/material.dart';
import 'package:shopping_app/auth/util/state_widget.dart';
import 'package:shopping_app/auth/ui/theme.dart';
import 'package:shopping_app/auth/ui/screens/sign_in.dart';
import 'package:shopping_app/auth/ui/screens/sign_up.dart';
import 'package:shopping_app/auth/ui/screens/forgot_password.dart';
import 'package:shopping_app/src/app.dart';

import 'auth/phone_auth.dart';

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
        '/': (context) => App(),
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
>>>>>>> 3dcee4613182da7e06eecfc7d0d0903e1e40a6e1
