import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/constants/color_const.dart';
import 'package:shopping_app/constants/string_constants.dart';
import 'package:shopping_app/src/models/sub_service_model.dart';
import 'package:shopping_app/src/screens/CustomShapeClipper.dart';
import 'package:shopping_app/src/utils/Dialogs.dart';
import '../widgets/CategoryCard.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'desc.dart';
import 'homecard/ServiceModel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  final String title = "Carousel Demo";

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  void dispose() {
    super.dispose();
  }

  HomeScreenState() {
    getalert();
    getOffers();
  }
  FirebaseUser user;

  CarouselSlider carouselSlider;
  int _current = 0;
  int servNo = 0;
  List imgList = [];
  List<String> cat = [];
  List<String> subCat = [];

  List<Widget> services = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.indigo));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                //child: Image.asset('assets/images/logo_in.png',height: 60,),

                child: Container(
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo_in.png',
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Mr. F i x r',
                        style: GoogleFonts.noticiaText(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.032,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.black),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Bhubaneswar',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
      body: ConnectivityWidgetWrapper(
        disableInteraction: true,
        message: intMsg,
              child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [catColor, catColor],
            ),
          ),
          child: ListView(
            children: <Widget>[
              Container(
                //clipper: CustomShapeClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.29,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [catColor, catColor],
                    ),
                  ),
                  child: imgList.length == 0
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            carouselSlider = CarouselSlider(
                              height: MediaQuery.of(context).size.height * 0.22,
                              initialPage: 0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              reverse: false,
                              enableInfiniteScroll: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              pauseAutoPlayOnTouch: Duration(seconds: 5),
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index) {
                                setState(() {
                                  _current = index;
                                });
                              },
                              items: imgList.map((imgUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: MediaQuery.of(context).size.height *
                                          0.22,
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // print(cat[_current]);
                                            // getDocument(cat[_current],
                                            //     subCat[_current]);
                                            _handleSubmit(context, cat[_current],
                                                subCat[_current]);
                                            //                 Navigator.of(context).push(
                                            // MaterialPageRoute(
                                            //   builder: (context) => Desc(
                                            //     service: SubServiceModel(
                                            //         subs[position],
                                            //         subsPrice[position],
                                            //         subsSid[position],
                                            //         subsDesc[position],
                                            //         subsProv[position],
                                            //         subsImg[position],
                                            //         subsRate[position]),
                                            //     user: user,
                                            //   ),
                                            // ),
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: imgUrl,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.22,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) {
                                              return Image.asset(
                                                  'assets/images/pcarousel.png');
                                            },
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: map<Widget>(imgList, (index, url) {
                                return Container(
                                  width: 10.0,
                                  height: 10.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('ServiceTypes')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return serviceTypeCards(context, snapshot);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  serviceTypeCards(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData)
      return Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            CircularProgressIndicator(),
            SizedBox(height: 5.0)
          ],
        ),
      );

    List<Service> data = List<Service>();

    for (var i = 0; i < snapshot.data.documents.length; i++)
      data.add(Service(
          snapshot.data.documents[i].documentID,
          snapshot.data.documents[i].data['url'],
          snapshot.data.documents[i].data['status']));

    return Container(
        height: MediaQuery.of(context).size.height * 0.57,
        decoration: new BoxDecoration(
          gradient: LinearGradient(
            colors: [catColor, catColor],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          child: Container(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height * 0.01, 0, 0),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white],
                    ),
                  ),
                  child: Text(
                    'Our Services',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tenaliRamakrishna(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GridView.count(
                    primary: false,
                    crossAxisCount: 3,
                    children: List.generate(data.length, (index) {
                      return CategoryCard(
                          data[index].serviceName,
                          data[index].serviceUrl,
                          data[index].serviceStat,
                          _scaffoldKey);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  getOffers() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('offers').getDocuments();
    List<DocumentSnapshot> documents = result.documents;
    for (int i = 0; i < documents.length; i++) {
      imgList.add(documents[i].data['url']);
      cat.add(documents[i].data['cat']);
      subCat.add(documents[i].data['subCat']);
    }
    setState(() {
      print(imgList.length);
    });
  }

  void getalert() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('alerts').getDocuments();
    if (result.documents.length != 0) {
      String k = result.documents[0].data.keys.toString();
      k = k.split('(')[1];
      k = k.split(')')[0];
      String v = result.documents[0].data.values.toString();
      v = v.split('(')[1];
      v = v.split(')')[0];
      showAlert(k, v);
    }
  }

  Future<void> showAlert(String k, String v) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(k),
          content: Text(
            v,
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSubmit(BuildContext context, String c1, String c2) async {
    Dialogs.showLoadingDialog(context, _keyLoader); //invoking login

    user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance
        .collection('ServiceTypes')
        .document(c1)
        .collection('sub')
        .document(c2)
        .get()
        .then((value) {
       Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Desc(
            service: SubServiceModel(c2, value['price'], value['sid'],
                value['desc'], value['prov'], value['url'], value['rate']),
            user: user,
          ),
        ),
      );
    });
  }
}
