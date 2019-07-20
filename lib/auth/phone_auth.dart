import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../src/app.dart';

import '../size_config.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  bool _saving = true;
  bool _isload = true;
  _PhoneAuthState() {
    getUser();
  }

  Future getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
    } else {
      setState(() {
        _isload = false;
      });
    }
  }

  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _smsController = new TextEditingController();
  String _phoneCode = '91';
  String verificationId;
  FirebaseUser user;
  var _keyField = GlobalKey<FormFieldState>();

  _buildCountryPickerDropdown() => Row(
        children: <Widget>[
          CountryPickerDropdown(
            initialValue: 'in',
          ),
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 2.0,
          ),
          Expanded(
            child: TextFormField(
              key: _keyField,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Phone"),
              validator: (val) {
                if (val.isEmpty) {
                  return "this field cannot be empty";
                }
              },
            ),
          )
        ],
      );

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );

  Future<void> verifyPhone(BuildContext context) async {
    try {
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        this.verificationId = verId;
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        this.verificationId = verId;
        smsCodeDialog(context).then((value) {
          print('Signed in');
        });
      };

      final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
        print('Successful verification');
        if (user != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => App()));
        } else {
          print("user is null");
        }
      } as PhoneVerificationCompleted;

      final PhoneVerificationFailed veriFailed = (AuthException exception) {
        print('Failed verification: ${exception.message}');
      };
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+${_phoneCode + _phoneController.text.trim()}",
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsCodeSent,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verifiedSuccess,
          verificationFailed: veriFailed);
    } catch (e) {
      print("error: $e");
      print('sex');
    }
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter sms Code'),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _smsController,
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () async {
                  AuthCredential credential = PhoneAuthProvider.getCredential(
                    verificationId: this.verificationId,
                    smsCode: _smsController.text.trim(),
                  );

                  user = await FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      print("Successful verification user is: $user");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => App()));
                    } else {
                      print("Failed verification");
                    }
                  }).catchError((e) {
                    print("error: $e");
                  });
                },
              )
            ],
          );
        });
  }

  flushBarMessage(BuildContext context, String msg) {
    Flushbar(
      message: "$msg",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: Colors.blue[300],
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    // loader();
    // setState(() {
    //   _saving = true;
    // });
    SizeConfig().init(context);
    if (_isload == true) {
      return new Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(),
        body: new Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Container(
        color: Colors.pink[400],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Get Started',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.pink[500]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: ListTile(title: _buildCountryPickerDropdown()),
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text("Verify"),
                color: Colors.white,
                textColor: Colors.pink[500],
                onPressed: () {
                  if (_phoneCode != null) {
                    if (_keyField.currentState.validate()) {
                      print("+${_phoneCode + _phoneController.text.trim()}");
                      verifyPhone(context);
                    }
                  } else {
                    flushBarMessage(context, "please select your code country");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
