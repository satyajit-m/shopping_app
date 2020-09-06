import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/constants/color_const.dart';
import 'package:shopping_app/constants/string_constants.dart';

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

  String slot = '10  AM - 12 PM';

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final Duration bookTimeDelay = Duration(days: 1);
  final String bookTimeDelayMsg =
      "Please choose time and date atleast 1 day from today.";

  TextEditingController notesController;

  DateTime _dateTime = DateTime.now();
  Future<DateTime> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateTime.add(Duration(days: 1)),
        firstDate: _dateTime.add(Duration(days: 1)),
        lastDate: _dateTime.add(Duration(days: 10)));
    if (picked != null && picked != _dateTime) {
      return picked;
    } else
      return null;
  }

  void getAddress() async {
    final DocumentSnapshot result =
        await Firestore.instance.document('users/' + widget.user.uid).get();
    setState(() {
      if (result.data.keys.length > 1) {
        address = Profile.mapToProfile(result.data);
        addressPresent = true;
      }
      addressFetched = true;
    });
  }

  Widget cartScreen(BuildContext context) {
    SizedBox theSpaceBetweenCards =
        SizedBox(height: MediaQuery.of(context).size.height * 0.01);

    return ConnectivityWidgetWrapper(
      disableInteraction: true,
                    message: intMsg,

          child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(widget.service.name),
            ),
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
                  color: iconBack,
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
                          color: Colors.blue),
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
                        DateTime pickedDate = await selectDate(context);

                        setState(() {
                          serviceDate = pickedDate;
                        });
                      },
                      child: Icon(serviceDate == null ? Icons.add : Icons.edit),
                    ),
                  ],
                ),
              ),
              serviceDate != null
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                beautifulDate(serviceDate),
                                softWrap: true,
                              ),
                              alignment: Alignment.topLeft,
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text('Choose Slot'),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  DropdownButton<String>(
                                    hint: Text('Choose Slot'),
                                    value: slot,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 18,
                                    elevation: 20,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurple,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        slot = newValue;
                                      });
                                    },
                                    items: <String>[
                                      '10  AM - 12 PM',
                                      '12  PM - 2 PM',
                                      ' 2  PM - 4 PM',
                                      ' 4  PM - 6 PM',
                                      ' 6  PM - 8 PM'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Container serviceMessage() {
    return Container(color: catColor,
      // elevation: 10,
      child: ListTile(
        title: Text('Order Details',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        subtitle: Text(
          "Service can be booked atleast 1day and atmost upto 10days in advance.",
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
                  color: iconBack,
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
                        color: Colors.blue,
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
                  color: Colors.orange[100],
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
                        flex: 3,
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
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
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
                                      "Please choose date for the service.",
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
                                      serviceDate: DateFormat('dd-MM-yyyy')
                                              .format(serviceDate)
                                              .toString() +
                                          ' ( ' +
                                          slot.toString() +
                                          ' )',
                                      address: address,
                                      notes: notes,
                                    ),
                                  ),
                                );
                              }
                            },
                            elevation: 1.5,
                            splashColor: Colors.indigo,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.indigo)),
                            child: Center(
                              child: Text(
                                'Pay Now',
                              ),
                            ),
                            textColor: Colors.indigo,
                          ),
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
                  color: iconBack,
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
                      "Additional Notes",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
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
