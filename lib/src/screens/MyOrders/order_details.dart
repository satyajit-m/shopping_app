import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/models/profile_model.dart';

class OrderDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  String usid, docId;

  OrderDetails(this.data, this.usid, this.docId);
  @override
  _OrderDetailsState createState() => _OrderDetailsState(data);
}

class _OrderDetailsState extends State<OrderDetails> {
  Map<String, dynamic> document;
  double h, w;

  _OrderDetailsState(this.document);
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(w * 0.025, 0, w * 0.025, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: h * 0.04,
                ),
                Container(
                  height: h*0.04,
                  alignment: Alignment(-1.0, -1.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.deepOrange[300],
                            size: h * 0.054,
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: SizedBox(
                      //     width: 5.0,
                      //   ),
                      // ),
                      Expanded(flex: 7,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            '${document['serviceDetails']['name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                SizedBox(
                  height: h * 0.04,
                ),
                Divider(
                  height: 2.0,
                  color: Colors.deepOrangeAccent,
                ),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .document(widget.usid)
                        .collection('orders')
                        .document(widget.docId)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: h * .1,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container(
                          margin:
                              EdgeInsets.fromLTRB(0.0, h * 0.02, 0, h * 0.01),
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
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.deepOrange[400],
                                            Colors.deepOrange[200]
                                          ]),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: w * 0.04,
                                        ),
                                        Text(
                                          "Order Details",
                                          style: TextStyle(
                                            fontSize: h * 0.025,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // padding:
                                    //     EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(w * 0.04),
                                    child: Align(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Order Status :',
                                                style: TextStyle(
                                                    fontSize: h * 0.025),
                                              ),
                                              Text(
                                                snapshot.data['responseStatus'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Booking Date :',
                                                style: TextStyle(
                                                    fontSize: h * 0.02),
                                              ),
                                              Text(
                                                '${document['transactionDate']}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Scheduled Date',
                                                style: TextStyle(
                                                    fontSize: h * 0.02),
                                              ),
                                              Text(
                                                '${document['serviceDateandTime']}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),
                                  Divider(
                                    height: 2.0,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(w * 0.04),
                                    height: h * 0.1,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.info,
                                              color: Colors.blueAccent,
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                                'Order once accepted cannot be cancelled')),
                                        Expanded(
                                            flex: 2,
                                            child: snapshot.data[
                                                        'responseStatus'] ==
                                                    'Processing'
                                                ? RaisedButton(
                                                    onPressed: () {
                                                      cancelOrder();
                                                    },
                                                    child: Text('Cancel'),
                                                    color:
                                                        Colors.deepOrange[400],
                                                    textColor: Colors.white,
                                                  )
                                                : Text('Cannot Cancel')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, h * 0.02, 0, h * 0.01),
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
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.deepOrange[400],
                                    Colors.deepOrange[200]
                                  ]),
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
                                  width: w * 0.04,
                                ),
                                Text(
                                  "Payment Details",
                                  style: TextStyle(
                                    fontSize: h * 0.025,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            // padding:
                            //     EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                          ),
                          Container(
                            padding: EdgeInsets.all(w * 0.04),
                            child: Align(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Payment Mode :',
                                        style: TextStyle(fontSize: h * 0.025),
                                      ),
                                      Text(
                                        '${document['paymentMode']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      document['paymentMode'] == 'COD'
                                          ? Text(
                                              'Amount to Pay :',
                                              style: TextStyle(
                                                  fontSize: h * 0.025),
                                            )
                                          : Text(
                                              'Amount Paid :',
                                              style: TextStyle(
                                                  fontSize: h * 0.025),
                                            ),
                                      Text(
                                        'Rs. ${document['serviceDetails']['price']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Order Id :',
                                        style: TextStyle(fontSize: h * 0.025),
                                      ),
                                      Text(
                                        '${document['paymentDetails']['txnRef']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Status :',
                                        style: TextStyle(fontSize: h * 0.025),
                                      ),
                                      Text(
                                        '${document['paymentDetails']['status']}',
                                        style: TextStyle(
                                            color: document['paymentDetails']
                                                        ['status'] ==
                                                    'FAILURE'
                                                ? Colors.redAccent
                                                : Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, h * 0.02, 0, h * 0.01),
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
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.deepOrange[400],
                                    Colors.deepOrange[200],
                                  ]),
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
                                  width: w * 0.04,
                                ),
                                Text(
                                  "Service Address",
                                  style: TextStyle(
                                    fontSize: h * 0.025,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            // padding:
                            //     EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                          ),
                          Container(
                            padding: EdgeInsets.all(w * 0.04),
                            child: Align(
                              child: Text(
                                Profile.mapToString(document['serviceAddress']),
                                style: TextStyle(fontSize: h * 0.0265),
                              ),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
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

  void cancelOrder() async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(widget.usid)
        .collection('orders')
        .document(widget.docId)
        .updateData({'responseStatus': 'Cancelled'});
  }
}
