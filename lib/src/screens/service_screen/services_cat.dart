import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_constants.dart';
import '../../models/sub_service_model.dart';
import '../../screens/desc.dart';
import 'package:shopping_app/constants/color_const.dart';
import 'package:line_icons/line_icons.dart';

class ServicesCat extends StatefulWidget {
  final String something;
  ServicesCat(this.something);

  @override
  ServicesCatState createState() => ServicesCatState(this.something);
}

class ServicesCatState extends State<ServicesCat> {
  FirebaseUser user;
  String something;
  List<String> subs = [];
  List<String> subsImg = [];
  List<int> subsPrice = [];
  List<int> subsSid = [];
  List<String> subsProv = [];
  List<String> subsDesc = [];
  List<String> subsRate = [];

  bool load;
  String head;
  double ht, wt;

  ServicesCatState(this.something) {
    head = this.something;
    load = true;
    getsubs(this.something);
  }

  @override
  Widget build(BuildContext context) {
    ht = MediaQuery.of(context).size.height;
    wt = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('$something'),
      ),
      body: ConnectivityWidgetWrapper(
        disableInteraction: true,
        message: intMsg,
        child: Container(
          child: load == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: subs.length,
                  itemBuilder: (context, position) {
                    return Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Desc(
                                service: SubServiceModel(
                                    subs[position],
                                    subsPrice[position],
                                    subsSid[position],
                                    subsDesc[position],
                                    subsProv[position],
                                    subsImg[position],
                                    subsRate[position]),
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: backText,
                              child: ListTile(
                                  title: Text(
                                    '${subs[position]}',
                                    style: TextStyle(
                                        fontSize: ht * 0.03,
                                        color: profileText),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward,
                                    color: profileText,
                                  )),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }

  void getsubs(String something) async {
    user = await FirebaseAuth.instance.currentUser();
    final QuerySnapshot result = await Firestore.instance
        .collection('ServiceTypes')
        .document(something)
        .collection('sub')
        .getDocuments();

    List<DocumentSnapshot> documents = result.documents;
    for (int i = 0; i < documents.length; i++) {
      subs.add(documents[i].documentID);
      subsImg.add(documents[i].data['url']);
      subsPrice.add(documents[i].data['price']);
      subsSid.add(documents[i].data['sid']);
      subsDesc.add(documents[i].data['desc']);
      subsProv.add(documents[i].data['prov']);
      subsRate.add(documents[i].data['rate']);
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
