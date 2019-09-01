import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import './confirmation.dart';

const delay = 5;

class UPIApps {
  static const String PayTM = "net.one97.paytm";
  static const String GooglePay = "com.google.android.apps.nbu.paisa.user";
  static const String BHIMUPI = "in.org.npci.upiapp";
  static const String PhonePe = "com.phonepe.app";
  // static const String MiPay = "com.mipay.wallet.in";
  static const String AmazonPay = "in.amazon.mShop.android.shopping";
  // static const String TrueCallerUPI = "com.truecaller";
  // static const String MyAirtelUPI = "com.myairtelapp";
}

class UPIResponse {
  String txnId;
  String responseCode;
  String approvalRefNo;
  String status;
  String txnRef;

  UPIResponse(String responseString) {
    List<String> _parts = responseString.split('&');

    for (int i = 0; i < _parts.length; ++i) {
      String key = _parts[i].split('=')[0];
      String value = _parts[i].split('=')[1];
      if (key == "txnId") {
        txnId = value;
      } else if (key == "responseCode") {
        responseCode = value;
      } else if (key == "ApprovalRefNo") {
        approvalRefNo = value;
      } else if (key.toLowerCase() == "status") {
        status = value;
      } else if (key == "txnRef") {
        txnRef = value;
      }
    }
  }
}

class UPI {
  static const MethodChannel _channel = const MethodChannel('flutter_upi');
  static Future<String> initiateTransaction(
      {@required String app,
      @required String pa,
      @required String pn,
      String mc,
      @required String tr,
      @required String tn,
      @required String am,
      @required String cu,
      @required String url}) async {
    final String response = await _channel.invokeMethod('initiateTransaction', {
      "app": app,
      'pa': pa,
      'pn': pn,
      'mc': mc,
      'tr': tr,
      'tn': tn,
      'am': am,
      'cu': cu,
      'url': url
    });
    return response;
  }
}

class PaymentGateway extends StatefulWidget {
  final double price;
  PaymentGateway({Key key, @required this.price});

  State<PaymentGateway> createState() {
    return PaymentGatewayState(price);
  }
}

class PaymentGatewayState extends State<PaymentGateway> {
  final double price;

  PaymentGatewayState(this.price);

  Future<bool> interruptMessage(
      String title, String msg, bool recoverable, BuildContext context) {
    return showDialog<bool>(
      barrierDismissible: recoverable,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: recoverable
              ? []
              : <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName("/home"),
                      );
                    },
                    child: Text("Ok"),
                  )
                ],
        );
      },
    );
  }

  final String _fixrUPI = "mysterion@ybl";
  var _transactionDetails = "";

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height / 2,
                floating: true,
                snap: true,
                pinned: true,
                elevation: 10,
                forceElevated: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "Paying ₹" + widget.price.toString(),
                    style: TextStyle(color: Colors.black54),
                  ),
                  background: Image.asset("assets/images/upi.png"),
                ),
              ),
            ];
          },
          body: Container(
            color: Colors.teal[100],
            child: ListView(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text("Google Pay"),
                    onTap: () async {
                      // String response = await UPI.initiateTransaction(
                      //   app: UPIApps.GooglePay,
                      //   pa: _fixrUPI,
                      //   pn: "Fixer Global",
                      //   tr: "1",
                      //   tn: "This is a transaction Note",
                      //   am: "1",
                      //   // mc: "YourMerchantId", // optional
                      //   cu: "INR",
                      //   url: "https://www.google.com",
                      // );
                      makePageWait("Waiting for payment", context);
                      bool status = await makePayment();
                      if (status) {
                        bool _datapushed =
                            await _pushCriticalData(_transactionDetails);
                        if (!_datapushed) {
                          Navigator.of(context, rootNavigator: true).pop();
                          await interruptMessage(
                            "Sorry",
                            "Something went wrong, if money was deducted from your account, we will refund it within 24 hours.",
                            false,
                            context,
                          );
                        } else {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Confirmation(
                                data: null,
                              ),
                            ),
                          );
                        }
                      } else {
                        String msg = "Something went wrong";
                        interruptMessage("Unsuccessful", msg, true, context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: Implement this
  Future<bool> makePayment() async {
    await Future.delayed(
      Duration(seconds: delay),
    );
    return true;
  }

  //requires the page to explicitly pop this from Navigator
  void makePageWait(String s, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Processing"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(s),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  //TODO: Implement this
  Future<bool> _pushCriticalData(transactionDetails) async {
    await Future.delayed(
      Duration(seconds: 0),
    );
    return true;
  }
}
