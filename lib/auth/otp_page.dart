import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app/constants/color_const.dart';
import 'package:shopping_app/constants/string_constants.dart';

class OtpPage extends StatefulWidget {
  final phoneNo;
  OtpPage({Key key, @required this.phoneNo});
  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {
  String verificationId;
  FirebaseUser user;
  final String _phoneCode = '91';

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  String getInput() {
    if (!validate())
      return "";
    else {
      return controller1.text +
          controller2.text +
          controller3.text +
          controller4.text +
          controller5.text +
          controller6.text;
    }
  }

  void logIn(AuthCredential credential) async {
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((currentUser) async {
      currentUser = await FirebaseAuth.instance.currentUser();
      if (currentUser != null) {
        successMatch("Automatically verified", currentUser, context);
      } else {
        badNews("Thats odd",
            "Couldn't contact our servers. Please try again later.", false);
      }
    });
  }

  void badNews(String title, String content, bool recoverable) {
    showDialog(
      barrierDismissible: recoverable,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: recoverable
              ? []
              : <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/auth");
                    },
                    child: Text("Ok"),
                  )
                ],
        );
      },
    );
  }

  Future<void> verifyPhone(BuildContext context) async {
    try {
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        this.verificationId = verId;
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        this.verificationId = verId;
      };

      final PhoneVerificationCompleted verifiedSuccess =
          (AuthCredential credential) async {
        //Auto Login
        logIn(credential);
      };

      final PhoneVerificationFailed veriFailed = (AuthException exception) {
        print('Failed verification: ${exception.message}');
        badNews("Unfortunately", "Verification Failed", true);
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+${_phoneCode + widget.phoneNo}",
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed,
      );
    } catch (e) {
      badNews(":(", "Verification via Phone failed. Please try Google Sign In",
          false);
    }
  }

  Future<void> createUserDb(FirebaseUser currentUser) async {
    print("DEBUG : " + currentUser.phoneNumber);
    if (currentUser != null) {
      final snapShot = await Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .get();

      if (snapShot == null || !snapShot.exists) {
        // Document with id == docId doesn't exist.
        final databaseReference = Firestore.instance;
        await databaseReference
            .collection('users')
            .document(currentUser.uid)
            .setData({
          'phone': currentUser.phoneNumber,
        });
      }
    }
  }

  void successMatch(
      String msg, FirebaseUser currentUser, BuildContext context) async {
    await createUserDb(currentUser);
    Navigator.pushReplacementNamed(context, '/home');
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text("Successful"),
    //       content: Text(msg),
    //       actions: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.check),
    //           onPressed: () {
    //             Navigator.of(context).popUntil((route) => route.isFirst);
    //             Navigator.pushReplacementNamed(context, '/home');
    //           },
    //         )
    //       ],
    //     );
    //   },
    // );
  }

  TextEditingController currController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
  }

  @override
  void initState() {
    super.initState();
    currController = controller1;
  }

  bool verifying = false;

  final _formKey = GlobalKey<FormState>();

  void matchOtp() async {
    String otp = getInput();
    if (otp.length != 0) {
      setState(() {
        verifying = true;
      });
      AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: this.verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((currentUser) async {
        currentUser = await FirebaseAuth.instance.currentUser();
        if (currentUser != null) {
          successMatch("OTP successfully verified", currentUser, context);
        } else {
          badNews(
              "Sorry :(", "Couldn't we verify you. Please try again.", false);
        }
      }).catchError((err) {
        setState(() {
          verifying = false;
        });
        badNews("Error", "Please Enter the OTP correctly", true);
      });
    } else {
      setState(() {
        verifying = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please Enter the OTP correctly"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    verifyPhone(context);
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                border:
                    Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
                borderRadius: BorderRadius.circular(4.0)),
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              enabled: false,
              controller: controller1,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border:
                  Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border:
                  Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border:
                  Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller4,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border:
                  Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller5,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            border: Border.all(
              width: 1.0,
              color: Color.fromRGBO(0, 0, 0, 0.1),
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller6,
            autofocus: false,
            enabled: false,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: 2.0,
          right: 0.0,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("OTP Verification"),
        backgroundColor: iconBack,
      ),
      backgroundColor: Color(0xFFeaeaea),
      body: ConnectivityWidgetWrapper(
      disableInteraction: true,
              message: intMsg,

              child: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Verifying your number!",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        top: 4.0,
                        right: 16.0,
                      ),
                      child: Text(
                        verifying
                            ? "Please wait while we verify OTP for"
                            : "Please type the verification code sent to",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        top: 2.0,
                        right: 30.0,
                      ),
                      child: Text(
                        "+91 " + widget.phoneNo,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: (verifying ? 55.0 : 16.0)),
                      child: verifying
                          ? Center(child: CircularProgressIndicator())
                          : Image(
                              image: AssetImage('assets/images/otp-icon.png'),
                              height: 120.0,
                              width: 120.0,
                            ),
                    )
                  ],
                ),
                flex: 90,
              ),
              Flexible(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GridView.count(
                        crossAxisCount: 8,
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        children: List<Container>.generate(
                          8,
                          (int index) => Container(
                            child: widgetList[index],
                          ),
                        ),
                      ),
                    ]),
                flex: 20,
              ),
              Flexible(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 16.0,
                            right: 8.0,
                            bottom: 0.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("1");
                                },
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("2");
                                },
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("3");
                                },
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("4");
                                },
                                child: Text(
                                  "4",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("5");
                                },
                                child: Text(
                                  "5",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("6");
                                },
                                child: Text(
                                  "6",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 4.0,
                            right: 8.0,
                            bottom: 0.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("7");
                                },
                                child: Text(
                                  "7",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("8");
                                },
                                child: Text(
                                  "8",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("9");
                                },
                                child: Text(
                                  "9",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) deleteText();
                                },
                                child: Image.asset('assets/images/delete.png',
                                    width: 25.0, height: 25.0),
                                disabledColor: Colors.red,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) inputTextToField("0");
                                },
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (verifying == false) matchOtp();
                                },
                                child: Image.asset(
                                  'assets/images/success.png',
                                  width: 25.0,
                                  height: 25.0,
                                ),
                                disabledColor: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      controller1.text = str;
      currController = controller2;
    }

    //Edit second textField
    else if (currController == controller2) {
      controller2.text = str;
      currController = controller3;
    }

    //Edit third textField
    else if (currController == controller3) {
      controller3.text = str;
      currController = controller4;
    }

    //Edit fourth textField
    else if (currController == controller4) {
      controller4.text = str;
      currController = controller5;
    }

    //Edit fifth textField
    else if (currController == controller5) {
      controller5.text = str;
      currController = controller6;
    }

    //Edit sixth textField
    else if (currController == controller6) {
      controller6.text = str;
      currController = controller6;
    }
  }

  void deleteText() {
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller5;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    } else if (currController == controller5) {
      controller4.text = "";
      currController = controller4;
    } else if (currController == controller6) {
      controller5.text = "";
      currController = controller5;
    }
  }

  bool validate() {
    if (controller1.text.length == 0 ||
        controller2.text.length == 0 ||
        controller3.text.length == 0 ||
        controller4.text.length == 0 ||
        controller5.text.length == 0 ||
        controller6.text.length == 0)
      return false;
    else
      return true;
  }
}
