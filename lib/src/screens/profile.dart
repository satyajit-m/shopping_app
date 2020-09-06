import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:line_icons/line_icons.dart';
import 'package:shopping_app/src/screens/MyOrders/myorders.dart';
import 'package:shopping_app/src/screens/help.dart';
import 'package:shopping_app/constants/color_const.dart';

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

  Widget build(BuildContext context) {
    ht = MediaQuery.of(context).size.height;
    wd = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        height: ht,
        child: StreamBuilder(
            stream: FirebaseAuth.instance.currentUser().asStream(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.data == null) {
                    return notLogged();
                  }
                  user = snapshot.data;
                  return logged(snapshot);
              }
            }),
      ),
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    prefix0.Navigator.pushReplacementNamed(context, "/");
    //Navigator.of(context).popUntil((route) => route.isFirst);
    //Navigator.of(context).pushNamed("/");
  }

  Widget notLogged() {
    return Container(
      height: ht * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: ht * 0.1,
          ),
          Container(
            width: wd,
            height: ht * 0.2,
            child: Image.asset(
              'assets/images/logo.png',
              height: ht * 0.2,
            ),
          ),
          SizedBox(
            height: ht * 0.1,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(12.0, 0.0, 6.0, 0.0),
            height: 40.0,
            width: wd * 0.6,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/phoneAuth');
              },
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                shadowColor: Colors.indigoAccent,
                color: Colors.blue,
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
          ),
        ],
      ),
    );
  }

  Widget logged(AsyncSnapshot<dynamic> snapshot) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        Card(
          color: Colors.deepOrange[50],
          elevation: 5,
          child: Column(children: <Widget>[
            Container(
              color: Colors.white,
              child: new ListTile(
                contentPadding: EdgeInsets.fromLTRB(0.0, 2.0, wd * 0.1, 5.0),
                leading: Icon(
                  Icons.person,
                  size: ht * 0.1,
                  color: Colors.black,
                ),
                title: Text(
                  'My Account',
                  style: TextStyle(fontSize: ht * 0.03, color: Colors.black),
                ),
                subtitle: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 2.0,
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text(
                            "${snapshot.data.phoneNumber}",
                            style: TextStyle(
                                fontSize: ht * 0.03, color: Colors.black),
                          ),
                          Text('')
                        ]),
                  ],
                ),
                isThreeLine: true,
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        // Divider(
        //   thickness: 1.0,
        // ),

        SizedBox(
          height: 15,
        ),
        Container(
          color: backText,
          child: ListTile(
            leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBack,
                ),
                child: Icon(
                  LineIcons.map_signs,
                  color: Colors.purple,
                  size: 30,
                )),
            title: Text(
              'My Address',
              style: TextStyle(fontSize: ht * 0.03, color: Colors.black),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: profileText),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/form');
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: backText,
          child: ListTile(
              leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBack,
                  ),
                  child: Icon(
                    Icons.assignment,
                    color: Colors.blue,
                    size: 30,
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyOrders(user)));
              },
              title: Text(
                'My Orders',
                style: TextStyle(fontSize: ht * 0.03, color: profileText),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: profileText)),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: backText,
          child: ListTile(
              leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBack,
                  ),
                  child: Icon(
                    Icons.help,
                    color: Colors.green,
                    size: 30,
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HelpScreen()));
              },
              title: Text(
                'Help & Support',
                style: TextStyle(fontSize: ht * 0.03, color: profileText),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: profileText)),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: backText,
          child: ListTile(
            leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBack,
                ),
                child: Icon(
                  Icons.share,
                  color: Colors.indigo,
                  size: 30,
                )),
            onTap: () {
              setState(() {
                //_lOut = true;
              });
              //logOut();
            },
            title: Text(
              'Share App',
              style: TextStyle(fontSize: ht * 0.03, color: profileText),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: profileText),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: backText,
          child: ListTile(
            leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBack,
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.yellow[700],
                  size: 30,
                )),
            onTap: () {
              setState(() {
                //  _lOut = true;
              });
              //logOut();
            },
            title: Text(
              'Rate & Review',
              style: TextStyle(fontSize: ht * 0.03, color: profileText),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: profileText),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: backText,
          child: ListTile(
            leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBack,
                ),
                child: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                  size: 30,
                )),
            onTap: () {
              setState(() {
                _lOut = true;
              });
              logOut();
            },
            title: Text(
              'Logout',
              style: TextStyle(fontSize: ht * 0.03, color: profileText),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: profileText),
          ),
        ),
      ],
    );
  }
}
