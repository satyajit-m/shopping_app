import 'package:flutter/material.dart';
import '../widgets/CategoryCard.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'homecard/ServiceBloc.dart';
import 'homecard/ServiceModel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super();

  final String title = "Carousel Demo";

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ServiceBloc _servicesBloc;

  @override
  void dispose() {
    _servicesBloc.dispose();
    super.dispose();
  }
  // @override
  // void dispose() {
  //   _servicesBloc.dispose();
  //   super.dispose();
  // }

  //
  CarouselSlider carouselSlider;
  int _current = 0;
  int servNo = 0;
  List imgList = ["https://firebasestorage.googleapis.com/v0/b/fixr-3b596.appspot.com/o/images%2FHomeSpa%2F6593a723.jpeg?alt=media&token=4453a0d3-2d1e-42ec-80db-2d4200a556c9",
  "https://firebasestorage.googleapis.com/v0/b/fixr-3b596.appspot.com/o/images%2FHomeSpa%2F6593a723.jpeg?alt=media&token=4453a0d3-2d1e-42ec-80db-2d4200a556c9"
    ];

  List<Widget> services = [];

  HomeScreenState() {
    //implement firestore here.
    //static list
    _servicesBloc = ServiceBloc();
  }

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
      
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              carouselSlider = CarouselSlider(
                height: MediaQuery.of(context).size.height * 0.2,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 5000),
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
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white30,
                        ),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(imgList, (index, url) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _current == index ? Colors.redAccent : Colors.green,
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: <Widget>[
                  StreamBuilder<List<Service>>(
                    stream: _servicesBloc.employeeListStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Service>> snapshot) {
                      if (!snapshot.hasData) return Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            CircularProgressIndicator(),
                            SizedBox(height: 5.0)
                          ],
                        ),
                      );
                      return new Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            if(index%2==0){
                            return callCategoryCard(
                                snapshot.data[index].serviceName,snapshot.data[index+1].serviceName,
                                snapshot.data[index].serviceUrl,snapshot.data[index+1].serviceUrl);}
                                else {
                                 return SizedBox(); 
                                }
                            // return Card(
                            //   elevation: 4.0,
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //     children: <Widget>[
                            //       Container(
                            //         padding: EdgeInsets.all(20.0),
                            //         child: Text(
                            //           "${snapshot.data[index].serviceName}",
                            //           style: TextStyle(fontSize: 18.0),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  Widget callCategoryCard(String serviceName1,String serviceName2 ,String serviceUrl1,String serviceUrl2) {
    return Row(
      children: <Widget>[
        Expanded(
          child:
              Column(children: <Widget>[CategoryCard(serviceName1, serviceUrl1)]),
        ),
        Expanded(
          child:
              Column(children: <Widget>[CategoryCard(serviceName2, serviceUrl2)]),
        ),
      ],
    );
  }
}
