import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/sub_service_model.dart';

import './cart.dart';

import '../models/profile_model.dart';

class Desc extends StatefulWidget {
  final SubServiceModel service;
  final FirebaseUser user;
  final String h1 = 'Package Description', h2 = 'Why Choose Us?';
  Desc({Key key, @required this.service, @required this.user})
      : super(key: key);

  DescState createState() {
    return DescState();
  }
}

class DescState extends State<Desc> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(widget.service.name),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Container(
                  //padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.service.img),
                        fit: BoxFit.cover),
                  ),
                ),
                textCard(
                    context,
                    '❖	 ' + widget.service.desc.split('.').join('\n❖  '),
                    widget.h1),
                textCard(
                    context,
                    '●  ' + widget.service.prov.split('.').join('\n●  '),
                    widget.h2),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                'assets/images/why1.png',
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Verified Personnel',
                                textAlign: TextAlign.center,
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                'assets/images/why3.png',
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Rework Assurance',
                                textAlign: TextAlign.center,
                              ),
                            ))
                          ],
                        ),
                        //width: MediaQuery.of(context).size.width * 0.2),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                'assets/images/why4.png',
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Professional Support',
                                textAlign: TextAlign.center,
                              ),
                            ))
                          ],
                        ),
                        //width: MediaQuery.of(context).size.width * 0.2),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Price Starts from - ${widget.service.price}',
                        //width: ,
                        style: TextStyle(
                            backgroundColor: Colors.orange[200],
                            fontSize:
                                MediaQuery.of(context).size.height * 0.03),
                      ),
                      bottomButton(context),
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

  Widget bottomButton(BuildContext context) {
    return RaisedButton(
      child: Text("Proceed"),
      onPressed: () {
        if (widget.user == null) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text("Please login to continue"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Cart(
                service: widget.service,
                user: widget.user,
                imgUrl: widget.service.img,
              ),
            ),
          );
        }
      },
      elevation: 1.5,
      color: Colors.orange,
      textColor: Colors.white,
    );
  }

  Widget textCard(BuildContext context, String txt, String head) {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Card(
        margin: EdgeInsets.all(7.0),
        elevation: 10,
        child: Column(
          children: <Widget>[
            Text(
              head,
              style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            Divider(),
            ListTile(
              title: Text(
                txt,
                textAlign: TextAlign.justify,
                textDirection: TextDirection.ltr,
              ),
              enabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
