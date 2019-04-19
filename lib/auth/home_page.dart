import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {

  FirebaseUser user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser user;
  void inputData() async {
    user = await FirebaseAuth.instance.currentUser();
    // here you write the codes to input the data into firestore
  }

  @override
  Widget build(BuildContext context) {
    inputData();
    return  SafeArea(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Home"),
        ),
        body: new Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: new Center(
            child: new Text("Hey: ${widget.user.phoneNumber}"),
          ),
        ),
      ),
    );
  }
}
