import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Shopping',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Shopping'),
        ),
        body: Center(
          child: Text('Hello There'),
        ),
      ),
    );
  }
}
