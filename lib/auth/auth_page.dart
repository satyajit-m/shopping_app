import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/app.dart';
import './phone_auth.dart';
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

  bool _isLoading = false;

  Future<bool> _loginUser() async {
    final api = await FBApi.signInWithGoogle();
    if (api != null) {
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
    SizeConfig().init(context);
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => PhoneAuth(),
                          );
                        },
                      ),
                    ),
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
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new App();
                            }));
                          } else {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("Wrong email or")));
                          }
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
}
