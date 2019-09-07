import 'package:flutter/material.dart';
import 'package:shopping_app/src/models/profile_model.dart';

class OrderDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  OrderDetails(this.data);
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
            padding: EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.02, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: h * 0.04,
                ),
                Container(
                  alignment: Alignment(-1.0, -1.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.blue,
                          size: h * 0.054,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '${document['serviceDetails']['name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
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
                              color: Colors.indigoAccent,
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
                                  "Order Details",
                                  style: TextStyle(
                                    fontSize: 20,
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
                                        style: TextStyle(fontSize: h * 0.03),
                                      ),
                                      Text(
                                        ' ${document['responseStatus']}',
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
                                        'Booking Date :',
                                        style: TextStyle(fontSize: h * 0.02),
                                      ),
                                      Text(
                                        '${document['transactionDate']}',
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
                                        'Scheduled Date',
                                        style: TextStyle(fontSize: h * 0.02),
                                      ),
                                      Text(
                                        '${document['serviceDateandTime']}',
                                        style: TextStyle(
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
                              color: Colors.indigoAccent,
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
                                    fontSize: 20,
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
                                        'Amount Paid :',
                                        style: TextStyle(fontSize: h * 0.03),
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
                                        style: TextStyle(fontSize: h * 0.03),
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
                                        style: TextStyle(fontSize: h * 0.03),
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
                              color: Colors.indigoAccent,
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
                                    fontSize: 20,
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
                                style: TextStyle(fontSize: h * 0.03),
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
}
