import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  State<Order> createState() {
    return OrderState();
  }
}

class OrderState extends State<Order> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Successfully Ordered"),
      )
    );
  }
}