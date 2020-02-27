import 'package:flutter/material.dart';
import 'package:shopping_app/src/screens/help.dart';
import 'package:shopping_app/src/screens/service_screen/services_cat.dart';

class CategoryCard extends StatelessWidget {

  final String cardName, cardUrl, cardStat;
  final _scaffoldkey;

  CategoryCard(this.cardName, this.cardUrl, this.cardStat,this._scaffoldkey);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(1),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.grey[200],
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepOrange[50], Colors.white]),
          ),
          child: InkWell(
            onTap: () {
              if (cardStat == 'false') {
                print('ok');
                _scaffoldkey.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Service Currently Under Maintenance"),
                    backgroundColor: Colors.deepOrange,
                  ),
                );
              } else {
                if (cardName == 'Others') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HelpScreen()));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ServicesCat('$cardName')),
                  );
                }
              }
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Image.network('$cardUrl')],
                  ),
                ),
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      this.cardName,
                      textAlign: TextAlign.center,
                    ))
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.15,
    );
  }
}
