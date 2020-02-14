import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/src/screens/CustomShapeClipper.dart';
import '../widgets/CategoryCard.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'homecard/ServiceModel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  final String title = "Carousel Demo";

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void dispose() {
    super.dispose();
  }

  HomeScreenState() {
    getOffers();
  }

  CarouselSlider carouselSlider;
  int _current = 0;
  int servNo = 0;
  List imgList = [];

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
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Expanded(flex:2,child: Text('FixR',style: GoogleFonts.abrilFatface(fontSize: MediaQuery.of(context).size.height*0.04),),),
          Expanded(flex: 1,child: Icon(Icons.location_on),),
          Expanded(flex: 2,child: Text('Bhubaneswar'),),
        ],
     )),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                //clipper: CustomShapeClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.27,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffF9A533), Color(0xffF77C08)],
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
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            carouselSlider = CarouselSlider(
                              height: MediaQuery.of(context).size.height * 0.19,
                              initialPage: 0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              reverse: false,
                              enableInfiniteScroll: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 5000),
                              pauseAutoPlayOnTouch: Duration(seconds: 10),
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
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        child: Image.network(
                                          imgUrl,
                                          fit: BoxFit.fill,
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
                                        : Colors.white,
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
                    Container(
                      width:MediaQuery.of(context).size.width ,
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffF9A533), Color(0xffF77C08)],
                        ),
                      ),
                      child: Text('Our Services',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    ),
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
      data.add(Service(snapshot.data.documents[i].documentID,
          snapshot.data.documents[i].data['url']));

    return Container(
        height: MediaQuery.of(context).size.height * 0.49,
        decoration: new BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffF9A533), Color(0xffF77C08)],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          child: Container(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height * 0.02, 0, 0),
            decoration: new BoxDecoration(
              color: Colors.grey[200],
            ),
            child: GridView.count(
              primary: false,
              crossAxisCount: 3,
              children: List.generate(data.length, (index) {
                return CategoryCard(
                    data[index].serviceName, data[index].serviceUrl);
              }),
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
    print(imgList.length);
    final QuerySnapshot result =
        await Firestore.instance.collection('offers').getDocuments();
    List<DocumentSnapshot> documents = result.documents;
    for (int i = 0; i < documents.length; i++) {
      imgList.add(documents[i].data['url']);
    }
    setState(() {
      print(imgList.length);
    });
  }
}
