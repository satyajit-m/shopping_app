import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:shopping_app/auth/auth_page.dart';
import 'package:shopping_app/src/screens/MyOrders/myorders.dart';
import 'package:shopping_app/src/screens/help.dart';

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
  bool _lOut = false;
  double ht, wd;
  ProfileScreenState() {
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

  Widget build(BuildContext context) {
    ht = MediaQuery.of(context).size.height;
    wd = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
                boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)],
              ),
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(height: 35.0),
            SizedBox(height: 8.0),
            phone == ""
                ? Container(
                    margin: EdgeInsets.fromLTRB(12.0, 0.0, 6.0, 0.0),
                    height: 40.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/phoneAuth');
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        shadowColor: Colors.deepOrangeAccent,
                        color: Colors.orange[400],
                        elevation: 5.0,
                        child: Center(
                          child: Text(
                            'Login ',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  )
                : Card(
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyOrders(user)));
                                },
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HelpScreen()));
                                },
                                title: Text(
                                  'Help & Support',
                                  style: TextStyle(
                                      fontSize: ht * 0.03,
                                      color: Colors.orange[400]),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.deepOrange[300])),
                            ListTile(
                                leading: Icon(Icons.location_city,
                                    color: Colors.deepOrange[300]),
                                title: Text(
                                  'My Address',
                                  style: TextStyle(
                                      fontSize: ht * 0.03,
                                      color: Colors.orange[400]),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.deepOrange[300])),
                            ListTile(
                              leading: Icon(Icons.exit_to_app,
                                  color: Colors.deepOrange[300]),
                              onTap: () {
                                setState(() {
                                  _lOut = true;
                                });
                                logOut();
                              },
                              title: Text(
                                'Logout',
                                style: TextStyle(
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
          ],
        ),
      ),
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    prefix0.Navigator.pushReplacementNamed(context, "/");
    //Navigator.of(context).popUntil((route) => route.isFirst);
    //Navigator.of(context).pushNamed("/");
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.2);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
