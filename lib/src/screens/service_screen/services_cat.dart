import 'package:flutter/material.dart';

class ServicesCat extends StatefulWidget{
  String something;
  ServicesCat(this.something);

  @override
  ServicesCatState createState() => ServicesCatState(this.something);
}

class ServicesCatState extends State<ServicesCat>{
  String something;

  ServicesCatState(this.something){

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('$something'),
      ),
      body:Text('$something')
    );
  }
}