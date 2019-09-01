import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shopping_app/src/screens/payment_gateway.dart';

import '../models/sub_service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/cube_grid.dart';
import '../models/profile_model.dart';
import './order.dart';

class Cart extends StatefulWidget {
  final SubServiceModel service;
  final FirebaseUser user;
  Cart({Key key, @required this.service, @required this.user})
      : super(key: key);

  CartState createState() {
    return CartState();
  }
}

class CartState extends State<Cart> {

  Profile address;
  bool addressFetched = false;
  bool addressPresent = false;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void getAddress() async {
    final DocumentSnapshot result =
        await Firestore.instance.document('users/' + widget.user.uid).get();
    setState(() {
      if (result.data.isNotEmpty) {
        address = Profile.mapToProfile(result.data);
        addressPresent = true;
      }
      addressFetched = true;
    });
  }

  Widget cartScreen(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 250,
                          width: double.infinity,
                        ),
                        Container(
                          height: 250.0,
                          width: double.infinity,
                          color: Colors.orange[700],
                        ),
                        Positioned(
                          bottom: 60.0,
                          right: 100.0,
                          child: Container(
                            height: 400,
                            width: 400.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200.0),
                              color: Colors.orange[500],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 110.0,
                          left: 150.0,
                          child: Container(
                              height: 300.0,
                              width: 300.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150.0),
                                  color: Colors.orange.withOpacity(0.5))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: IconButton(
                            alignment: Alignment.topLeft,
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Positioned(
                          top: 75.0,
                          left: 15.0,
                          child: Text(
                            widget.service.name,
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
          ),
          addressFetched
              ? (addressPresent ? yesAddress() : noAddress())
              : loadingAddress(),
        ],
      ),
    );
  }

  Widget yesAddress() {
    String currentAddress = modify(Profile.profileToString(address));
    double containerHeight = (currentAddress.split("\n").length + 5) * 25.0;
    return Container(
      height: containerHeight,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        child: Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/profile/form')
                                .then((onValue) => setState(() {
                                      addressFetched = false;
                                    }));
                          },
                          child: Icon(Icons.mode_edit),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ],
                ),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Align(
                    child: Text(
                      modify(Profile.profileToString(address)),
                      softWrap: true,
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noAddress() {
    return Container(
      height: 64,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.green,
        elevation: 10,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        child: Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/profile/form')
                                .then(
                                  (onValue) => setState(() {
                                    addressFetched = false;
                                  }),
                                );
                          },
                          child: Icon(Icons.add),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ],
                ),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String modify(String s) {
    var sa = s.split("\n");
    sa.removeLast();
    return sa.join("\n");
  }

  Widget loadingAddress() {
    getAddress();
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CubeGrid(
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: cartScreen(context),
      bottomNavigationBar: bottomBar(context),
    );
  }

  Widget bottomBar(BuildContext context) {
    return Material(
      elevation: 10.0,
      color: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Price: ₹ ' + widget.service.price.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Final Pricing will be based on inspection",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (!addressPresent) {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Please add your Address"),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentGateway()
                                )
                              );
                            }
                          },
                          elevation: 1.5,
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              'Pay Now',
                            ),
                          ),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  paymentInvoke() async {
    String response = await FlutterUpi.initiateTransaction(
      app: FlutterUpiApps.PayTM,
      pa: "9437462217@paytm",
      pn: "Receiver Name",
      mc: "YourMerchantId",       // optional
      tr: "UniqueTransactionId",
      tn: "This is a transaction Note",
      am: "8.00",
      cu: "INR",
      url: "https://www.google.com",
    );

    print(response);
    // FlutterUpiResponse flutterUpiResponse = FlutterUpiResponse(response);
    // print(flutterUpiResponse.txnId); // prints transaction id
    // print(flutterUpiResponse.txnRef); //prints transaction ref
    // print(flutterUpiResponse.Status); //prints transaction status
    // print(flutterUpiResponse.ApprovalRefNo); //prints approval reference number
    // print(flutterUpiResponse.responseCode); //prints the response code
  }
}

class FlutterUpiApps {
  static const String PayTM = "net.one97.paytm";
  static const String GooglePay = "com.google.android.apps.nbu.paisa.user";
  static const String BHIMUPI = "in.org.npci.upiapp";
  static const String PhonePe = "com.phonepe.app";
  static const String MiPay = "com.mipay.wallet.in";
  static const String AmazonPay = "in.amazon.mShop.android.shopping";
  static const String TrueCallerUPI = "com.truecaller";
  static const String MyAirtelUPI = "com.myairtelapp";
}

class FlutterUpiResponse {
  String txnId;
  String responseCode;
  String ApprovalRefNo;
  String Status;
  String txnRef;

  FlutterUpiResponse(String responseString) {
    List<String> _parts = responseString.split('&');

    for (int i = 0; i < _parts.length; ++i) {
      String key = _parts[i].split('=')[0];
      String value = _parts[i].split('=')[1];
      if (key == "txnId") {
        txnId = value;
      } else if (key == "responseCode") {
        responseCode = value;
      } else if (key == "ApprovalRefNo") {
        ApprovalRefNo = value;
      } else if (key.toLowerCase() == "status") {
        Status = value;
      } else if (key == "txnRef") {
        txnRef = value;
      }
    }
  }
}

class FlutterUpi {
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
