import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../utils/beautiful_date.dart';

import './payment/payment_gateway.dart';

import '../models/sub_service_model.dart';

import '../models/profile_model.dart';

class Cart extends StatefulWidget {
  final SubServiceModel service;
  final FirebaseUser user;
  final String imgUrl;
  Cart({Key key, @required this.service, @required this.user, this.imgUrl})
      : super(key: key);

  CartState createState() {
    return CartState();
  }
}

class CartState extends State<Cart> {
  Profile address;
  bool addressFetched = false;
  bool addressPresent = false;

  initState() {
    notesController = TextEditingController();
    super.initState();
  }

  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  DateTime serviceDate;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final Duration bookTimeDelay = Duration(hours: 1);
  final String bookTimeDelayMsg =
      "Please choose time and date atleast 1 hour from now.";

  TextEditingController notesController;

  Future<DateTime> datePicker(BuildContext ctxt, DateTime initTime) async {
    DateTime returnValue = serviceDate;

    DateTime currentTime = DateTime.now();

    if (initTime == null) {
      initTime = currentTime.add(bookTimeDelay);
    }

    await showModalBottomSheet(
      context: ctxt,
      builder: (ctxt) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  fontFamily: 'roboto',
                  fontSize: 18,
                ),
              ),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              use24hFormat: false,
              initialDateTime: initTime,
              maximumDate: currentTime.add(Duration(days: 7)),
              minimumDate: currentTime,
              onDateTimeChanged: (value) {
                print(returnValue.toString());
                returnValue = value;
              },
            ),
          ),
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
    SizedBox theSpaceBetweenCards =
        SizedBox(height: MediaQuery.of(context).size.height * 0.01);

    return Scaffold(
     
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text(widget.service.name),),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                theSpaceBetweenCards, //
                serviceMessage(),
                theSpaceBetweenCards, //
                addressFetched
                    ? (addressPresent ? yesAddress() : noAddress())
                    : loadingAddress(),
                theSpaceBetweenCards, //
                datePickerWidget(context),
                theSpaceBetweenCards, //
                addNotes(),
                theSpaceBetweenCards, //
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container datePickerWidget(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.80;
    return Container(
      width: cWidth,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        child: Container(
          child: Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(serviceDate == null ? 10 : 0),
                    bottomRight: Radius.circular(serviceDate == null ? 10 : 0),
                  ),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Service Date",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime pickedDate =
                            await datePicker(context, serviceDate);
                        if (pickedDate.difference(DateTime.now()).isNegative) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                bookTimeDelayMsg,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          setState(() {
                            serviceDate = pickedDate;
                          });
                        }
                      },
                      child: Icon(serviceDate == null ? Icons.add : Icons.edit),
                    ),
                  ],
                ),
              ),
              serviceDate != null
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        beautifulDate(serviceDate),
                        softWrap: true,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Card serviceMessage() {
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text(
          "It is recommended to book this service atleast 1 day in advance.",
        ),
        enabled: true,
      ),
    );
  }

  Widget yesAddress() {
    var fontSize = 16.0;
    String currentAddress = modify(Profile.profileToString(address));
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        child: Container(
          child: Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/profile/form')
                            .then((onValue) => setState(() {
                                  addressFetched = false;
                                }));
                      },
                      child: Icon(Icons.mode_edit),
                    ),
                  ],
                ),
                // padding:
                //     EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Align(
                  child: Text(
                    modify(Profile.profileToString(address)),
                    softWrap: true,
                    style: TextStyle(fontSize: fontSize),
                  ),
                  alignment: Alignment.topLeft,
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        child: Container(
          child: Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Address",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile/form').then(
                              (onValue) => setState(() {
                                addressFetched = false;
                              }),
                            );
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
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
                            } else if (serviceDate == null) {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please choose time and date for the service.",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (serviceDate
                                .difference(DateTime.now())
                                .isNegative) {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    bookTimeDelayMsg,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              String notes = notesController.value.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentGateway(
                                    service: widget.service,
                                    serviceDate: serviceDate,
                                    address: address,
                                    notes: notes,
                                  ),
                                ),
                              );
                            }
                          },
                          elevation: 1.5,
                          color: Colors.orange,
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

  Widget addNotes() {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        child: Container(
          child: Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Addtional Notes",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    hintText: "To help us serve you better",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
