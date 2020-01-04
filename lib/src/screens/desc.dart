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
  Desc({Key key, @required this.service, @required this.user})
      : super(key: key);

  DescState createState() {
    return DescState();
  }
}

class DescState extends State<Desc> {
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 10,
            forceElevated: true,
            expandedHeight: 200.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.service.name,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16.0,
                ),
              ),
              background: Image.network(
                widget.service.img,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                textCard(context,
                    ' ✓	 ' + widget.service.desc.split('.').join('\n✓	  ')),
                textCard(context,
                    '✓  ' + widget.service.prov.split('.').join('\n\n✓  ')),
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
                      Text('Price Starts from - ${widget.service.price}',style: TextStyle(backgroundColor: Colors.orangeAccent),),
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Cart(
              service: widget.service,
              user: widget.user,
              imgUrl: widget.service.img,
            ),
          ),
        );
      },
      elevation: 1.5,
      color: Colors.orange,
      textColor: Colors.white,
    );
  }

  Widget textCard(BuildContext context, String txt) {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Card(
        margin: EdgeInsets.all(7.0),
        elevation: 10,
        child: ListTile(
          title: Text(
            txt,
          ),
          enabled: true,
        ),
      ),
    );
  }
}
