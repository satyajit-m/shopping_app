import 'package:flutter/material.dart';
import '../../models/cart_model.dart';
import '../../../size_config.dart';

class CartScreen extends StatefulWidget {
  final Service service;

  CartScreen({Key key, @required this.service}) : super(key: key);

  createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                    ),
                    Container(
                      height: 250.0,
                      width: double.infinity,
                      color: Color(0xFFFDD148),
                    ),
                    Positioned(
                      bottom: 450.0,
                      right: 100.0,
                      child: Container(
                        height: 400.0,
                        width: 400.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: Color(0xFFFEE16D),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 500.0,
                      left: 150.0,
                      child: Container(
                          height: 300.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150.0),
                              color: Color(0xFFFEE16D).withOpacity(0.5))),
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
                        widget.service.name,
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
            )
          ],
        )
      ],
    );
  }
}
