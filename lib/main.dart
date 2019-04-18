import 'package:flutter/material.dart';
import 'src/app.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Shopping',
      home: App(),
      theme: ThemeData(
        primaryColor: Colors.indigoAccent,
      ),
    ),
  );
}
