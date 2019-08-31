import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Map> nm = [
    {
      'oid': '12',
      'nam': 'SM1',
      'st': 'Laundry',
      'dt': '23Aug',
      'tm': '13:54',
      'sts': 'Success'
    },
    {
      'oid': '13',
      'nam': 'SM2',
      'st': 'Plumber',
      'dt': '18Aug',
      'tm': '16:32',
      'sts': 'Failed'
    }
  ];
  List<String> name = ["SM1", "SM2"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                alignment: Alignment(-1.0, -1.0),
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "My Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                alignment: Alignment(-1.0, -1.0),
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 3.0, bottom: 3.0, left: 10.0, right: 10.0),
                      child: const Text(
                        'All Orders',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                margin: EdgeInsets.only(right: 10.0, left: 10.0),
                child: new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Container(
                      margin: const EdgeInsets.all(1),
                      padding: const EdgeInsets.all(1),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15.0),
                        padding: EdgeInsets.all(5.0),
                        child: ListTile(
                          //leading: FlutterLogo(size: 72.0),
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  nm[index]['st'],
                                  style: TextStyle(fontSize: 23.0),
                                ),
                                Text('Id: ${nm[index]['oid']}'),
                              ],
                            ),
                          ),
                          subtitle: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('${nm[index]['dt']} | ${nm[index]['tm']}'),
                                nm[index]['sts'] == 'Failed'
                                    ? Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 30.0,
                                      )
                                    : Icon(
                                        Icons.done_outline,
                                        color: Colors.green,
                                        size: 30.0,
                                      )
                              ],
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.blue,
                            size: 40.0,
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: new Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
