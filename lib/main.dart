import 'package:flutter/material.dart';
import 'src/app.dart';

import './auth/phone_auth.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Shopping',
      home: new PhoneAuth(),
      theme: ThemeData(
        primaryColor: Colors.indigoAccent,
      ),
    ),
  );
}
