import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import './cart_screen/cart_screen.dart';

class Cart extends StatefulWidget {
  final Service service;

  Cart({Key key, @required this.service}) : super(key: key);

  CartState createState() {
    return CartState();
  }
}

class CartState extends State<Cart> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: CartScreen(
        service: widget.service,
      ),
      /*Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                  Text("Price : " + widget.service.price.toString())
            ],
          ),
        ),
      )*/
      bottomNavigationBar: Material(
        elevation: 7.0,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Price: ₹ ' +
                                      widget.service.price.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Final Pricing will be based on inspection",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {},
                            elevation: 1.5,
                            color: Colors.red,
                            child: Center(
                              child: Text(
                                'Pay Now',
                              ),
                            ),
                            textColor: Colors.white,
                          ),
                        ),
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
