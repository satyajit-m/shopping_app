import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/sub_service_model.dart';
import '../../screens/cart.dart';

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
                itemCount: subs.length,
                itemBuilder: (context, position) {
                  return Container(
                    margin: const EdgeInsets.all(1),
                    padding: const EdgeInsets.all(1),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Cart(
                              service: SubServiceModel(
                                  subs[position], subsPrice[position], subsSid[position]),
                              user: user,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        //leading: FlutterLogo(size: 72.0),
                        title: Container(
                          child: Text('${subs[position]}'),
                        ),
                        subtitle: Container(child: Divider(),),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.blue,
                          size: 40.0,
                        ),
                      ),
                      
                    ),
                  );
                },
              ),
      ),
    );
  }

  //      return Card(
  //        elevation: 5.0,

  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: <Widget>[
  //             Container(
  //               padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
  //               child: Image.network(subsImg[position]),
  //               height: 100,
  //             ),
  //             Container(
  //               padding: EdgeInsets.all(20.0),
  //               child: Text(
  //                 subs[position],
  //                 style: TextStyle(fontSize: 18.0),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   },
  //   itemCount: subs.length,
  // ),
  // ),
  //);

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
