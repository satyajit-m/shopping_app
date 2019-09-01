import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/cupertino.dart';

import './payment/payment_gateway.dart';

import '../models/sub_service_model.dart';

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

  var serviceDate;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<DateTime> datePicker(BuildContext ctxt) async {
    DateTime returnValue;
    DateTime currentTime = DateTime.now();
    await showModalBottomSheet(
      context: ctxt,
      builder: (ctxt) {
        return CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          use24hFormat: false,
          initialDateTime: currentTime,
          maximumDate: currentTime.add(Duration(days: 7)),
          minimumDate: currentTime,
          onDateTimeChanged: (value) {
            returnValue = value;
          },
        );
      },
    );
    return returnValue;
  }

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
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 10,
              forceElevated: true,
              expandedHeight: 200.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  widget.service.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                background: Image.network(
                  "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: ListView(
          padding: EdgeInsets.only(left: 10, right: 10, top: 20),
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text(
                  "It is recommended to book this service atleast 1 day in advance.",
                ),
                enabled: true,
              ),
            ),
            Card(
              child: ListTile(
                leading: serviceDate == null
                    ? Icon(
                        Icons.warning,
                        color: Colors.red,
                      )
                    : null,
                title: Text(
                    serviceDate == null ? "Pick a service date" : serviceDate),
                onTap: () async {
                  serviceDate = (await datePicker(context)).toIso8601String();
                  print(serviceDate);
                  setState(() {});
                },
              ),
            ),
            addressFetched
                ? (addressPresent ? yesAddress() : noAddress())
                : loadingAddress(),
          ],
        ),
      ),
    );
  }

  Widget yesAddress() {
    var fontSize = 16.0;
    String currentAddress = modify(Profile.profileToString(address));
    double containerHeight = (currentAddress.split("\n").length + 5) *
        fontSize *
        (0.3 + MediaQuery.textScaleFactorOf(context));
    return Container(
      height: containerHeight,
      padding: EdgeInsets.only(top: 10),
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
                      style: TextStyle(fontSize: fontSize),
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
      padding: EdgeInsets.only(top: 10),
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
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
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
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10,
                                ),
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
                                    builder: (context) => PaymentGateway(
                                        price: widget.service.price.toDouble()),
                                  ));
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
}
