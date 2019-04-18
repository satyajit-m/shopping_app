import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
 HelpScreenState createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(50.0),
        child: Text('Help', style: TextStyle(color: Colors.white, fontSize: 48.0)),
      ),
    );
  }
}