import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  double h, w;

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
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: h * 0.04,
              ),
              Container(
                alignment: Alignment(-1.0, -1.0),
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.blue,
                        size: h * 0.054,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "My Orders",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(),
                  Container(
                    //alignment: Alignment(-1.0, -1.0),
                    child: Container(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 7.0, right: 7.0),
                          child: const Text(
                            'All Orders',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //alignment: Alignment(-1.0, -1.0),
                    padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 7.0, right: 7.0),
                          child: const Text(
                            'Success',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //alignment: Alignment(-1.0, -1.0),
                    padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 7.0, right: 7.0),
                          child: const Text(
                            'Failed',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
              SizedBox(
                height: h * 0.04,
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
                          color: Color(0xffDBF2FE),
                          border: new Border.all(color: Colors.grey[300]),
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
