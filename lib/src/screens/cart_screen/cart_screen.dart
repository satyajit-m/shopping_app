import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/cube_grid.dart';
import '../../models/sub_service_model.dart';
import '../../../size_config.dart';
import '../../models/profile_model.dart';
import '../../forms/profile_form.dart';

class CartScreen extends StatefulWidget {
  final SubServiceModel service;
  final FirebaseUser user;

  CartScreen({Key key, @required this.service, @required this.user})
      : super(key: key);

  createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {
  Profile address;
  bool addressFetched = false;
  bool addressPresent = false;

  SubServiceModel service;
  FirebaseUser user;

  void initState() {
    service = widget.service;
    user = widget.user;
    super.initState();
  }

  void getAddress() async {
    final DocumentSnapshot result =
        await Firestore.instance.document('users/' + user.uid).get();
    print(result.data);
    setState(() {
      if (result.data.isNotEmpty) {
        address = Profile.mapToProfile(result.data);
        addressPresent = true;
      }
      addressFetched = true;
    });
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: ListView(
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
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
          ),
          addressFetched
              ? (addressPresent ? yesAddress() : noAddress())
              : loadingAddress(),
        ],
      ),
    );
  }

  Widget yesAddress() {
    String currentAddress = modify(Profile.profileToString(address));
    double containerHeight = (currentAddress.split("\n").length + 5) * 25.0;
    return Container(
      height: containerHeight,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
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
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                .then((onValue) => setState(() {
                                      addressFetched = false;
                                    }));
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
