import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../CustomShapeClipper.dart';
import 's2.dart';

class ServicesCat extends StatefulWidget {
  String something;
  ServicesCat(this.something);

  @override
  ServicesCatState createState() => ServicesCatState(this.something);
}

class ServicesCatState extends State<ServicesCat> {
  String something;
  List<String> subs = [];
  List<String> subsImg = [];
  bool load;

  ServicesCatState(this.something) {
    load = true;
    getsubs(this.something);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ok'),
      ),
      body: Container(
        padding: EdgeInsets.all(6.0),
        child: load == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, position) {
                  return Card(
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20.0,0,0,0),
                          child: Image.network('${subsImg[position]}'),
                          height: 100,
                        ),
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "${subs[position]}",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: subs.length,
              ),
      ),
    );
  }

  void getsubs(String something) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('ServiceTypes')
        .document('$something')
        .collection('sub')
        .getDocuments();

    List<DocumentSnapshot> documents = result.documents;
    for (int i = 0; i < documents.length; i++) {
      subs.add(documents[i].documentID);
      subsImg.add(documents[i].data['url']);
    }
    setState(() {
      load = false;
    });
  }
}

class ServicesTopPart extends StatefulWidget {
  @override
  _ServicesTopPartState createState() => _ServicesTopPartState();
}

class _ServicesTopPartState extends State<ServicesTopPart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          //clipper: CustomShapeClipper(),
          child: Container(
            height: 300.0,
            color: Colors.orange,
          ),
        )
      ],
    );
  }
}
