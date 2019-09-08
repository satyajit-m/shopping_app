import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../size_config.dart';

class AuthPage extends StatefulWidget {
  AuthPageState createState() {
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser user;
  bool userLoaded = false;

  bool _isLoading = false;

  AuthPageState() {
    getUser();
  }

  Future createUserDb() async {
    user = await FirebaseAuth.instance.currentUser();
    bool newuser = false;
    if (user != null) {
      Map<String, dynamic> transactionMap = {};
      DocumentReference dbUserRef =
          Firestore.instance.collection("users").document(user.uid);
      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(dbUserRef);
        if (!snapshot.exists) {
          await transaction.set(dbUserRef, transactionMap);
          newuser = true;
        }
      });
    }
    return newuser;
  }

  final PageColor = Colors.white;
  final LogoColor = Colors.green[600];
  final TextColor = Colors.green[600];
  final TextBoxColor = Colors.greenAccent[600];
  final IconColor = Colors.blue[200];

  Widget build(BuildContext context) {

    if (!userLoaded) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    SizeConfig().init(context);
    if (_isLoading) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: PageColor),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Builder(builder: (BuildContext context) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 70,
                      child: Image.asset(
                        'assets/images/logo.png',
                        color: LogoColor,
                      ),
                    ),
                    Container(
                      color: TextBoxColor,
                      width: SizeConfig.blockSizeHorizontal * 60,
                      child: RaisedButton.icon(
                        textColor: PageColor,
                        disabledColor: Colors.grey,
                        icon: Icon(
                          Icons.phone,
                          color: IconColor,
                        ),
                        label: Text(
                          "Sign In With Phone",
                          style: TextStyle(
                            color: TextColor,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/phoneAuth');
                        },
                      ),
                    ),
                    FlatButton(
                      textColor: TextColor,
                      child: Text("Skip"),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        userLoaded = true;
      });
    }
  }
}
