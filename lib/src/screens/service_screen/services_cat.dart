import 'package:flutter/material.dart';
import 's2.dart';

class ServicesCat extends StatefulWidget {
  String something;
  ServicesCat(this.something);

  @override
  ServicesCatState createState() => ServicesCatState(this.something);
}

class ServicesCatState extends State<ServicesCat> {
  String something;

  ServicesCatState(this.something) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ok'),
      ),
      body: Container(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => S2()),
            );
          },
          child: Text('Press'),
        ),
      ),
    );
  }
}
