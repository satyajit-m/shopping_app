import 'package:flutter/material.dart';
import 'auth/login_screen3.dart';
import 'src/app.dart';

import './auth/phone_auth.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Shopping',
      home: Container(
        child: LoginScreen3(),
      ),
      theme: ThemeData(
        primaryColor: Colors.indigoAccent,
      ),
    ),
  );
}
