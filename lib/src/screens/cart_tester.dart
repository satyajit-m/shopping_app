import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cart.dart';

import '../models/sub_service_model.dart';

class Tester extends StatefulWidget {
  final FirebaseUser user;
  Tester({Key key, @required this.user});

  createState() {
    return TesterState();
  }
}

class TesterState extends State<Tester> {

  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("OpenCart"),
          onPressed: () {
            final name = "Bull Milk";
            final price = "699";
            final serviceId = "78";
            final x = SubServiceModel(name, price, serviceId);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Cart(
                  service: x,
                  user: widget.user,
                ),
              ),
            );
          },
        ),
      ),
    ),);
  }
}
