import 'dart:ui';

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
  final LogoColor = Colors.orange;
  final TextColor = Colors.white;
  final TextBoxColor = Colors.transparent;
  final IconColor = Colors.white;

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
      child: Scaffold(
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.blueGrey.withOpacity(0.25), BlendMode.dstATop),
              image: new ExactAssetImage('assets/images/back.png'),
            ),
          ),
          child: new Container(
            child: Stack(
              children: <Widget>[
                Scaffold(
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
                                'assets/images/logo_in.png',
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Container(
                              color: TextBoxColor,
                              width: SizeConfig.blockSizeHorizontal * 60,
                              child: RaisedButton.icon(
                                color: Colors.orange,
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
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.025),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
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
