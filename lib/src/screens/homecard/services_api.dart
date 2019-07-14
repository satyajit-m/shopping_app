// import 'dart:async';

// void fetchCollection() async {
//     final QuerySnapshot result =
//         await Firestore.instance.collection('services').getDocuments();
//     List<DocumentSnapshot> documents = result.documents;
//     var list = result.documents;

//     for (var i = 0; i < documents.length; i++) {
//       print('-----\n---------');

//       print(documents[i].documentID);
//     }
//     print('-----\n---------');

//     //print(list.toString());
//   }