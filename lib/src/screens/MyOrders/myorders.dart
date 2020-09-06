import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/constants/color_const.dart';
import 'package:shopping_app/constants/string_constants.dart';
import 'package:shopping_app/src/screens/MyOrders/order_details.dart';

class MyOrders extends StatefulWidget {
  final FirebaseUser user;
  MyOrders(this.user);
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  double h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConnectivityWidgetWrapper(
      disableInteraction: true,
              message: intMsg,

              child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: h * 0.04,
                  ),
                  Container(
                    alignment: Alignment(-1.0, -1.0),
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.black,
                            size: h * 0.054,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "My Orders",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(),
                      Container(
                        //alignment: Alignment(-1.0, -1.0),
                        child: Container(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 3.0, bottom: 3.0, left: 8.0, right: 8.0),
                              child: const Text(
                                'All Orders',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                     
                      SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.04,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10.0, left: 10.0),
                    child: OrderList(widget.user),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final FirebaseUser user;
  String usid;
  OrderList(this.user) {
    usid = this.user.uid;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document('$usid')
          .collection('orders')
          .orderBy('transactionDate', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data.documents.length > 0) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItems(context, snapshot.data.documents[index]),
            );
          } else {
            return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Text('No Orders !! Go to Home to place an Order '),
                ));
          }
        }
      },
    );
  }

  Widget _buildListItems(BuildContext context, DocumentSnapshot document) {
    String dt = DateFormat('dd-MM-yyyy – kk:mm:ss')
        .format((document['transactionDate'].toDate()))
        .toString();
    //DateTime.parse(document['transactionDate']).toString();
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(1),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.0),
        padding: EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderDetails(document.data, usid, document.documentID)),
            );
          },
          child: ListTile(
            //leading: FlutterLogo(size: 72.0),
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      document['serviceDetails']['name'],
                    ),
                  )

                  //Text('Id: ${document.documentID}'),
                ],
              ),
            ),
            subtitle: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(dt),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.blue,
              size: 40.0,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: iconBack,
          border: new Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
