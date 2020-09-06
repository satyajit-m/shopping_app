import 'dart:ui';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/constants/string_constants.dart';

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
  final LogoColor = Colors.teal;
  final TextColor = Colors.white;
  final TextBoxColor = Colors.transparent;
  final IconColor = Colors.white;

  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
          body: ConnectivityWidgetWrapper(
        disableInteraction: true,
        message: intMsg,
        child: Container(
          height: double.maxFinite,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Align(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 200,
                        width: SizeConfig.blockSizeHorizontal * 70,
                        child: Image.asset(
                          'assets/images/logo.png',
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                      userLoaded == false
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            )
                          : Column(
                              children: <Widget>[
                                Container(
                                  color: TextBoxColor,
                                  width: SizeConfig.blockSizeHorizontal * 70,
                                  child: RaisedButton.icon(
                                    color: Colors.blue,
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/phoneAuth');
                                    },
                                  ),
                                ),
                                FlatButton(
                                  textColor: TextColor,
                                  child: Text(
                                    "Skip For Now",
                                    style: TextStyle(
                                        color: Colors.grey,
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
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Image.asset(
                            'assets/images/name.png',
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/images/hands.png',
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }

  void getUser() async {
    Future.delayed(Duration(seconds: 3), () async {
      user = await FirebaseAuth.instance.currentUser();

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          userLoaded = true;
        });
      }
    });
  }
}
