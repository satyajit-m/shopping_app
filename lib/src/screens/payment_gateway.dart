import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';

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
  State<PaymentGateway> createState() {
    return PaymentGatewayState();
  }
}

class PaymentGatewayState extends State<PaymentGateway> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Payment"),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Google Pay"),
              onTap: () async {
                String response = await UPI.initiateTransaction(
                  app: UPIApps.GooglePay,
                  pa: "mysterion@ybl",
                  pn: "Debadutta Padhial",
                  tr: "1",
                  tn: "This is a transaction Note",
                  am: "1",
                  // mc: "YourMerchantId", // optional
                  cu: "INR",
                  url: "https://www.google.com",
                );

                print(response);
              },
            ),
            ListTile(
              title: Text("Amazon Pay"),
              onTap: () async {
                String response = await UPI.initiateTransaction(
                  app: UPIApps.AmazonPay,
                  pa: "lunu1997@okhdfcbank",
                  pn: "Debadutta Padhial",
                  tr: "2",
                  tn: "This is a transaction Note",
                  am: "1",
                  // mc: "YourMerchantId", // optional
                  cu: "INR",
                  url: "https://www.google.com",
                );

                print(response);
              },
            ),
            ListTile(
              title: Text("BHIM UPI"),
              onTap: () async {
                String response = await UPI.initiateTransaction(
                  app: UPIApps.BHIMUPI,
                  pa: "lunu1997-1@okhdfcbank",
                  pn: "Debadutta Padhial",
                  tr: "2",
                  tn: "This is a transaction Note",
                  am: "1",
                  // mc: "YourMerchantId", // optional
                  cu: "INR",
                  url: "https://www.google.com",
                );

                print(response);
              },
            ),
          ],
        ));
  }
}
