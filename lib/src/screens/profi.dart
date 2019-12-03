import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  // FirebaseUser user;
  // ProfileScreen(this.user);

  ProfileScreen({Key key}) : super(key: key);

  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser user;
  String phone = "";
  String picUrl = "";
  bool _lOut;
  double ht, wd;

  ProfileScreenState() {
    _lOut = false;
    getUser();
  }

  Future getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      phone = user.phoneNumber.toString();
      picUrl = user.photoUrl.toString();
      setState(() {});
    }
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    ht = MediaQuery.of(context).size.height;
    wd = MediaQuery.of(context).size.width;

    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Container(
          margin:
              EdgeInsets.fromLTRB(wd * 0.02, ht * 0.05, wd * 0.02, ht * 0.05),
          child: Column(
            children: <Widget>[
              Container(
                child: Card(
                  color: Colors.deepOrange[50],
                  elevation: 10.0,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            EdgeInsets.fromLTRB(0.0, 2.0, wd * 0.1, 0.0),
                        leading: Icon(
                          Icons.person,
                          size: ht * 0.09,
                          color: Colors.deepOrange[300],
                        ),
                        title: Text(
                          'My Account',
                          style: TextStyle(
                              fontSize: ht * 0.03, color: Colors.orange[400]),
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 2.0,
                            ),
                            Divider(
                              thickness: 2.0,
                              color: Colors.orange[400],
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Text(
                                    "$phone",
                                    style: TextStyle(
                                        fontSize: ht * 0.03,
                                        color: Colors.orange[400]),
                                  ),
                                  Text('')
                                ]),
                          ],
                        ),
                        //trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children:
                            ListTile.divideTiles(context: context, tiles: [
                          ListTile(
                              leading: Icon(Icons.assignment,
                                  color: Colors.deepOrange[300]),
                              title: Text(
                                'My Orders',
                                style: TextStyle(
                                    fontSize: ht * 0.03,
                                    color: Colors.orange[400]),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.deepOrange[300])),
                          ListTile(
                              leading: Icon(Icons.help,
                                  color: Colors.deepOrange[300]),
                              title: Text('Help & Support',style: TextStyle(
                                    fontSize: ht * 0.03,
                                    color: Colors.orange[400]),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.deepOrange[300])),
                          ListTile(
                              leading: Icon(Icons.location_city,
                                  color: Colors.deepOrange[300]),
                              title: Text('My Address',style: TextStyle(
                                    fontSize: ht * 0.03,
                                    color: Colors.orange[400]),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.deepOrange[300])),
                          ListTile(
                            leading: Icon(Icons.exit_to_app,
                                color: Colors.deepOrange[300]),
                                onTap: (){
                                  setState(() {
                                      _lOut = true;
                                    });
                                    logOut();
                                },
                            title: Text('Logout',style: TextStyle(
                                    fontSize: ht * 0.03,
                                    color: Colors.orange[400]),
                              ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.deepOrange[300]),
                          ),
                        ]).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
