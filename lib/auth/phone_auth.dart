import 'package:flutter/material.dart';
import './otp_page.dart';
import '../remove_scroll_glow.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  String _phoneCode = '91';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Phone",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xFFeaeaea),
      body: ScrollConfiguration(
        behavior: RemoveScrollGlow(),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 20.0, right: 16.0),
                    child: Text(
                      "Enter your phone number",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Image(
                      image: AssetImage('assets/images/otp-icon.png'),
                      height: 120.0,
                      width: 120.0,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: new Container(),
                        flex: 1,
                      ),
                      Flexible(
                        child: new TextFormField(
                          textAlign: TextAlign.center,
                          autofocus: false,
                          enabled: false,
                          initialValue: "+" + _phoneCode,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                        flex: 3,
                      ),
                      Flexible(
                        child: new Container(),
                        flex: 1,
                      ),
                      Flexible(
                        child: Form(
                          key: _formKey,
                          child: new TextFormField(
                            controller: _phoneController,
                            textAlign: TextAlign.start,
                            autofocus: true,
                            enabled: true,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                            validator: (val) {
                              if (val.isEmpty)
                                return "this field cannot be empty";
                              if (val.length != 10)
                                return "Should be a 10 digit phone number";
                              return null;
                            },
                          ),
                        ),
                        flex: 9,
                      ),
                      Flexible(
                        child: new Container(),
                        flex: 1,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                    child: new Container(
                      width: 150.0,
                      height: 40.0,
                      child: new RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print("haha");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpPage(
                                  phoneNo: _phoneController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text("Get OTP"),
                        textColor: Colors.white,
                        color: Colors.red,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ])
          ],
        ),
      ),
    );
  }
}
