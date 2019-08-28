import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './phone_auth.dart';
import '../src/models/profile_model.dart';
import '../src/widgets/cube_grid.dart';
import '../size_config.dart';
import 'google_auth.dart';

class AuthPage extends StatefulWidget {
  AuthPageState createState() {
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  /* GOOGLE SIGNIN START */
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

  Future<bool> _loginUser() async {
    FirebaseUser api = await signInWithGoogle();
    if (api != null) {
      print(await createUserDb());
      return true;
    } else {
      return false;
    }
  }

  /* GOOGLE SIGNIN END */

  final PageColor = Colors.white;
  final LogoColor = Colors.green[600];
  final TextColor = Colors.green[600];
  final TextBoxColor = Colors.greenAccent[600];
  final IconColor = Colors.blue[200];

  Widget build(BuildContext context) {
    // SchedulerBinding.instance.addPostFrameCallback((_) => getUser);

    if (!userLoaded) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: CubeGrid(
              color: LogoColor,
              size: MediaQuery.of(context).size.width * 0.90,
            ),
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PhoneAuth()),
                          );
                        },
                      ),
                    ),
                    /*
                    Container(
                      color: TextBoxColor,
                      width: SizeConfig.blockSizeHorizontal * 60,
                      child: RaisedButton.icon(
                        textColor: PageColor,
                        disabledColor: Colors.grey,
                        icon: ImageIcon(
                          AssetImage('assets/images/google_logo.png'),
                          color: IconColor,
                        ),
                        label: Text(
                          "Sign In With Google",
                          style: TextStyle(
                            color: TextColor,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () async {
                          setState(() => _isLoading = true);

                          bool b = await _loginUser();

                          setState(() => _isLoading = false);

                          if (b == true) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                      ),
                    ),*/
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
