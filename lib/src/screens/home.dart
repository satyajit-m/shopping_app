import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
 HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(50.0),
        child: Text('Home', style: TextStyle(color: Colors.white, fontSize: 48.0)),
      ),
    );
  }
}