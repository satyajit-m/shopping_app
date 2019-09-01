import 'package:flutter/material.dart';

class Confirmation extends StatefulWidget {
  //TODO: make this something fixed
  final dynamic data;
  Confirmation({Key key, @required this.data});
  State<Confirmation> createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: true,
                floating: true,
                snap: true,
                pinned: true,
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
          //TODO: Add StreamBuilder
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
                Card(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 30, bottom: 30, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("Waiting for service confirmation"),
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
}
