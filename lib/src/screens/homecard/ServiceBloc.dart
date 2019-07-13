//Imports
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ServiceModel.dart';

//List of Employees
class ServiceBloc {
  List<Service> _serviceList = new List();

  //sink to add in pipe
  //stream to get data from pipe
  //pipe -> data flow

  //Stream Controllers

  final _serviceListStreamController = StreamController<List<Service>>();

  //for inc and dec

  //Stream Sink Getter
  //getters

  Stream<List<Service>> get employeeListStream =>
      _serviceListStreamController.stream;

  StreamSink<List<Service>> get employeeListSink =>
      _serviceListStreamController.sink;

  //Constructor - add data; listen to changes

  ServiceBloc() {
    fetchCollection();
  }

  //Core functions
  Future<void> fetchCollection() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('testServ').getDocuments();
    List<DocumentSnapshot> documents = result.documents;
    var list = result.documents;

    for (var i = 0; i < documents.length; i++) {
      // _serviceList[i].serviceName = documents[i].documentID;
      var doc = documents[i].documentID.toString();
      DocumentSnapshot querySnapshot = await Firestore.instance
          .collection('testServ')
          .document('$doc')
          .get();
      if (querySnapshot.exists) {
        _serviceList.add(new Service(
            documents[i].documentID, querySnapshot.data['url']));
      } else {
        print('ok');
      }

      //_serviceList[i].serviceUrl = documents[i].documentID;
    }
    _serviceListStreamController.add(_serviceList);
  }

  //Dispose

  void dispose() {
    _serviceListStreamController.close();
  }
}
