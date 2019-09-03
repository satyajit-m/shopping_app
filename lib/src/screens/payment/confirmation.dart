import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Confirmation extends StatefulWidget {
  //TODO: make this something fixed
  final String tid;
  final FirebaseUser user;
  Confirmation({Key key, @required this.tid, @required this.user});
  State<Confirmation> createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  // 0 -> loading
  // 1 -> approved
  // 2 -> disapproved
  int ico = 0;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: true,
                pinned: true,
                floating: true,
                elevation: 10,
                forceElevated: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "Payment Successful",
                  ),
                ),
              ),
            ];
          },
          body: Container(
            color: Colors.teal[100],
            child: ListView(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("users")
                      .document(widget.user.uid)
                      .collection("orders")
                      .document(widget.tid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    String text = "Waiting for service confirmation";

                    if (!snapshot.hasData) {
                      text = "loading...";
                    } else {
                      Map<String, dynamic> data = snapshot.data.data;
                      assert(snapshot.data.exists == true);
                      if (data["responseStatus"] != "none") {
                        if (data["responseStatus"] == "yes") {
                          ico = 1;
                        } else {
                          ico = 2;
                        }
                        text = data["responseMsg"];
                      }
                    }

                    return Card(
                      semanticContainer: false,
                      elevation: 10,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 5,
                          right: 5,
                        ),
                        child: ListTile(
                          leading: (ico == 0
                              ? CircularProgressIndicator()
                              : (ico == 1
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ))),
                          title: Text(text),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
