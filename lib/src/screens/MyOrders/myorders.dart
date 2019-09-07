import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/screens/MyOrders/order_details.dart';
import 'package:shopping_app/src/utils/beautiful_date.dart';

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
      body: SafeArea(
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
                          color: Colors.blue,
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
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 3.0, bottom: 3.0, left: 7.0, right: 7.0),
                            child: const Text(
                              'All Orders',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ), 
                        ),
                      ),
                    ),
                    // Container(
                    //   //alignment: Alignment(-1.0, -1.0),
                    //   padding: EdgeInsets.only(left: 15.0),
                    //   child: Container(
                    //     child: DecoratedBox(
                    //       decoration: BoxDecoration(
                    //         color: Colors.green,
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(15.0),
                    //         ),
                    //       ),
                    //       child: Padding(
                    //         padding: EdgeInsets.only(
                    //             top: 3.0, bottom: 3.0, left: 7.0, right: 7.0),
                    //         child: const Text(
                    //           'Success',
                    //           style: TextStyle(
                    //               fontSize: 20.0, color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   //alignment: Alignment(-1.0, -1.0),
                    //   padding: EdgeInsets.only(left: 15.0),
                    //   child: Container(
                    //     child: DecoratedBox(
                    //       decoration: BoxDecoration(
                    //         color: Colors.red,
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(15.0),
                    //         ),
                    //       ),
                    //       child: Padding(
                    //         padding: EdgeInsets.only(
                    //             top: 3.0, bottom: 3.0, left: 7.0, right: 7.0),
                    //         child: const Text(
                    //           'Failed',
                    //           style: TextStyle(
                    //               fontSize: 20.0, color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //),
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
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                _buildListItems(context, snapshot.data.documents[index]),
          );
        }
      },
    );
  }

  Widget _buildListItems(BuildContext context, DocumentSnapshot document) {
    String dt =
        beautifulDateOnly(DateTime.parse('${document['transactionDate']}'));
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
              MaterialPageRoute(builder: (context) => OrderDetails(document.data)),
            );
          },
          child: ListTile(
            //leading: FlutterLogo(size: 72.0),
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    document['serviceDetails']['name'],
                    style: TextStyle(fontSize: 25.0),
                  ),
                  //Text('Id: ${document.documentID}'),
                ],
              ),
            ),
            subtitle: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${document['transactionDate']}'),
                  document['paymentDetails']['status'] == 'FAILURE'
                      ? Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 30.0,
                        )
                      : Icon(
                          Icons.done_outline,
                          color: Colors.green,
                          size: 30.0,
                        )
                ],
              ),
            ),
            // trailing: Icon(
            //   Icons.chevron_right,
            //   color: Colors.blue,
            //   size: 40.0,
            // ),
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xffDBF2FE),
          border: new Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
