import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {

  final String cardName;

  CategoryCard(this.cardName);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(cardName, textAlign: TextAlign.center,),
            ),
          ],
        ),
      );
  }
}