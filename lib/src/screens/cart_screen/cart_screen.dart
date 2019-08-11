import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/cube_grid.dart';
import '../../models/cart_model.dart';
import '../../../size_config.dart';
import '../../models/profile_model.dart';
import '../../forms/profile_form.dart';

class CartScreen extends StatefulWidget {
  final Service service;
  final FirebaseUser user;

  CartScreen({Key key, @required this.service, @required this.user})
      : super(key: key);

  createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {
  Profile address;
  var z = 0;
  bool addressFetched = false;
  bool addressPresent = false;

  Service service;
  FirebaseUser user;

  void initState() {
    service = widget.service;
    user = widget.user;
    super.initState();
    getAddress();
  }

  void getAddress() async {
    final DocumentSnapshot result =
        await Firestore.instance.document('users/' + user.uid).get();
    print(result.data);
    setState(() {
      if (result.data.isNotEmpty) {
        address = mapToProfile(result.data);
        addressPresent = true;
      }
      addressFetched = true;
    });
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 250,
                        width: double.infinity,
                      ),
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        color: Colors.orange[700],
                      ),
                      Positioned(
                        bottom: 60.0,
                        right: 100.0,
                        child: Container(
                          height: 400,
                          width: 400.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200.0),
                            color: Colors.orange[500],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 110.0,
                        left: 150.0,
                        child: Container(
                            height: 300.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150.0),
                                color: Colors.orange.withOpacity(0.5))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: IconButton(
                          alignment: Alignment.topLeft,
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Positioned(
                        top: 75.0,
                        left: 15.0,
                        child: Text(
                          service.name,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Positioned(
                      //     top: 125.0,
                      //     left: 15,
                      //     child: Container(
                      //       child: Column(
                      //         children: <Widget>[
                      //           Text("Final Pricing will be based on inspection")
                      //         ],
                      //       ),
                      //     )),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 200,
          width: 600,
          padding: EdgeInsets.all(10),
          child: addressFetched
              ? (addressPresent ? yesAddress() : noAddress())
              : loadingAddress(),
          //noAddress(), //addressPresent ? yesAddress() : noAddress(),
        ),
      ],
    );
  }

  Widget yesAddress() {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                child: Text(
                  modify(profileToString(address)),
                  softWrap: true,
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Expanded(
              child: Align(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile/form');
                  },
                  child: Icon(Icons.mode_edit),
                ),
                alignment: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noAddress() {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                child: Text(
                  "Add Address",
                  softWrap: true,
                  style: TextStyle(fontSize: 15),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ),
            Expanded(
              child: Align(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile/form');
                  },
                  child: Icon(Icons.edit),
                  ),
                alignment: Alignment.bottomRight,
              ),
            ),
          ],
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
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CubeGrid(
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
}
