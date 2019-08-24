import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app/src/screens/payment/flutter_upi.dart';
import '../models/sub_service_model.dart';
import './cart_screen/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: CartScreen(
        service: widget.service,
        user: widget.user,
      ),
      bottomNavigationBar: Material(
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
                                      fontWeight: FontWeight.w300,
                                      fontSize: 10),
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
                              paymentInvoke();
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
