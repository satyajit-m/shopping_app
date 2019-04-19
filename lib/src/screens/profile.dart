import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {




  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {



  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(50.0),
        child:
        Text('Profile', style: TextStyle(color: Colors.white, fontSize: 48.0)),
      ),
    );
  }
}