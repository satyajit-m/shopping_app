import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_app/src/utils/beautiful_date.dart';
import 'package:device_apps/device_apps.dart';
import '../../models/sub_service_model.dart';
import 'package:flutter/material.dart';

import '../../utils/random_string.dart';
import '../../models/profile_model.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import './confirmation.dart';

const _debugPrice = true;
const _fixrUrl = "https://fixr.netlify.com/";
const _payeeName = "Fixr Global";

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

  static toMap(UPIResponse res) {
    Map<String, String> returnData = {};
    returnData["txnId"] = res.txnId ?? "";
    returnData["responseCode"] = res.responseCode ?? "";
    returnData["approvalRefNo"] = res.approvalRefNo ?? "";
    returnData["status"] = res.status ?? "";
    returnData["txnRef"] = res.txnRef ?? "";
    return returnData;
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
  final String notes;
  final Profile address;
  final SubServiceModel service;
  final DateTime serviceDate;

  PaymentGateway(
      {Key key,
      @required this.service,
      @required this.serviceDate,
      @required this.address,
      @required this.notes});

  State<PaymentGateway> createState() {
    return PaymentGatewayState();
  }
}

class PaymentGatewayState extends State<PaymentGateway> {
  FirebaseUser user;
  var _pgKey = GlobalKey<ScaffoldState>();

  void initState() {
    fetchUser();
    super.initState();
  }

  fetchUser() async {
    user = await FirebaseAuth.instance.currentUser();
    assert(user != null);
  }

  PaymentGatewayState() {
    Random provider = Random.secure();
    _tid = randomAlpha(
          3,
          provider: CoreProvider.from(provider),
        ) +
        DateTime.now().millisecondsSinceEpoch.toString();
  }

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

  final String _fixrUPI = "7540915155@paytm";
  Map<String, dynamic> _tDetails = {
    "responseStatus": "none",
    "responseMsg": ""
  };
  String _tid;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _pgKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              floating: false,
              pinned: false,
              elevation: 10,
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Paying ₹" + widget.service.price.toString(),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: MediaQuery.of(context).size.height * 0.15,
              delegate: upiAppsList(context),
            ),
          ],
          // body: Container(
          //   color: Colors.teal[100],
          //   child: upiAppsList(context),
          // ),
        ),
      ),
    );
  }

  Future<Map<String, String>> makePayment(String servicePackage) async {
    print(_tid);
    String response = await UPI.initiateTransaction(
      app: servicePackage,
      pa: _fixrUPI,
      pn: _payeeName,
      tr: _tid,
      tn: "$_tid",
      am: widget.service.price.toString(),
      // mc: "YourMerchantId", // optional
      cu: "INR",
      url: _fixrUrl,
    );
    print("UPI String Response : $response");
    return UPIResponse.toMap(
      UPIResponse(response),
    );
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

  Future<bool> _pushCriticalData() async {
    DocumentReference newOrderRef = Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection("orders")
        .document(_tid);
    DocumentReference adminTransaction =
        Firestore.instance.collection("transactions").document(_tid);

    await Firestore.instance.runTransaction(
      (transaction) async {
        DocumentSnapshot snapshot = await transaction.get(newOrderRef);
        if (!snapshot.exists) {
          await transaction.set(newOrderRef, _tDetails);
        } else {
          throw Exception(
              "Order ID Already present. Use a better random string generator");
        }
      },
    );

    await Firestore.instance.runTransaction(
      (transaction) async {
        DocumentSnapshot snapshot = await transaction.get(adminTransaction);
        if (!snapshot.exists) {
          await transaction.set(adminTransaction, _tDetails);
        } else {
          throw Exception("Order ID Already present. Use a better order ID");
        }
      },
    );

    return true;
  }

  SliverChildBuilderDelegate upiAppsList(BuildContext context) {
    const int listLength = 5;

    const appPackageList = [
      UPIApps.GooglePay,
      UPIApps.BHIMUPI,
      UPIApps.AmazonPay,
      UPIApps.PhonePe,
    ];

    const appNameList = ["Google Pay", "BHIM UPI", "Amazon Pay", "Phone Pe"];

    const appLogoList = ["gpay.png", "bhim.png", "apay.png", "ppay.png"];

    return SliverChildBuilderDelegate(
      (context, index) {
        // For COD
        if (index == listLength - 1) {
          return Container(
            padding: const EdgeInsets.all(5),
            child: Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.asset("assets/images/cod.png"),
                  title: Text("Cash On Delivery"),
                  onTap: () async {
                    makePageWait("please wait..", context);

                    _tDetails["paymentMode"] = "COD";

                    Map<String, String> paymentData = {"status": "SUCCESS"};

                    bool status = true;

                    _tDetails["transactionDate"] = DateTime.now().toString();

                    _tDetails["notes"] = widget.notes;

                    _tDetails["serviceAddress"] =
                        Profile.profileToMap(widget.address);

                    _tDetails["serviceDetails"] = widget.service.toMap();

                    _tDetails["serviceDateandTime"] =
                        widget.serviceDate.toString();

                    _tDetails["paymentDetails"] = paymentData;

                    bool _datapushed = await _pushCriticalData();

                    Navigator.of(context, rootNavigator: true)
                        .pop(); //for makePageWait

                    if (!_datapushed) {
                      await interruptMessage(
                        "Sorry",
                        "We couldn't contact our servers.",
                        false,
                        context,
                      );
                    }

                    if (status) {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName("/home"));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Confirmation(
                            tid: _tid,
                            user: user,
                          ),
                        ),
                      );
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                ),
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(5),
          child: Card(
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.asset("assets/images/" + appLogoList[index]),
                title: Text(appNameList[index]),
                onTap: () async {
                  bool isInstalled =
                      await DeviceApps.isAppInstalled(appPackageList[index]);

                  if (!isInstalled) {
                    _pgKey.currentState.removeCurrentSnackBar();
                    _pgKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          "${appNameList[index]} is not installed on your device.",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  makePageWait("Waiting for payment", context);

                  _tDetails["paymentMode"] = "UPI";

                  Map<String, String> paymentData =
                      await makePayment(appPackageList[index]);

                  print(paymentData["status"]);

                  bool status = paymentData["status"].toLowerCase() == "success"
                      ? true
                      : false;

                  _tDetails["transactionDate"] = DateTime.now().toString();

                  _tDetails["notes"] = widget.notes;

                  _tDetails["serviceAddress"] =
                      Profile.profileToMap(widget.address);

                  _tDetails["serviceDetails"] = widget.service.toMap();

                  _tDetails["serviceDateandTime"] =
                      widget.serviceDate.toString();

                  _tDetails["paymentDetails"] = paymentData;

                  if (!status) {
                    await interruptMessage(
                        "Unsuccessful",
                        "Something went wrong, if money was deducted from your account, we will refund it within 24 hours.",
                        true,
                        context);
                  }

                  bool _datapushed = await _pushCriticalData();

                  Navigator.of(context, rootNavigator: true)
                      .pop(); //for makePageWait

                  if (!_datapushed) {
                    await interruptMessage(
                      "Sorry",
                      "Couldn't reach our servers, if money was deducted from your account, please contact us.",
                      false,
                      context,
                    );
                  }

                  if (status) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 80,
                        ),
                        title: Text('Order Successful'),
                      ),
                    );

                    Future.delayed(const Duration(milliseconds: 2000), () {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName("/home"));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Confirmation(
                            tid: _tid,
                            user: user,
                          ),
                        ),
                      );
                    });
                  } else {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                          size: 80,
                        ),
                        title: Text('Sorry Order Unsuccessful'),
                      ),
                    );
                    Future.delayed(const Duration(milliseconds: 2000), () {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  }
                },
              ),
            ),
          ),
        );
      },
      childCount: listLength,
    );
  }
}
