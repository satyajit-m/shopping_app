import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/sub_service_model.dart';
import '../../screens/desc.dart';

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
  bool load;

  ServicesCatState(this.something) {
    load = true;
    getsubs(this.something);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: load == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  const SliverAppBar(
                    pinned: true,
                    expandedHeight: 250.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('Demo'),
                    ),
                  ),
                  SliverList(
                    // Use a delegate to build items as they're scrolled on screen.
                    delegate: SliverChildBuilderDelegate(
                      (context, position) {
                        return Container(
                          margin: const EdgeInsets.all(1),
                          padding: const EdgeInsets.all(1),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Desc(
                                    service: SubServiceModel(subs[position],
                                        subsPrice[position], subsSid[position], subsDesc[position], subsProv[position]),
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
                              subtitle: Container(
                                child: Divider(),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.deepOrange,
                                size: 40.0,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: subs.length,
                    ),
                  )
                ],
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
      ),
    );
  }

  // ListView.builder(
  //                         itemCount: subs.length,
  //                         itemBuilder: (context, position) {
  //return
  //                         },
  //                       ),

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
      subsDesc.add(documents[i].data['desc']);
      subsProv.add(documents[i].data['prov']);
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
