import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  // FirebaseUser user;
  // ProfileScreen(this.user);

  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser user;
  String phone;
  ProfileScreenState() {
    getUser();
  }

  Future getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    phone = user.phoneNumber.toString();
    print(phone);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(50.0),
        child: Text('Profile ${phone}',
            style: TextStyle(color: Colors.white, fontSize: 48.0)),
      ),
    );
  }
}
