import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/auth/auth_page.dart';
import 'package:shopping_app/src/screens/MyOrders/myorders.dart';

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
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.deepOrangeAccent),
            clipper: getClipper(),
          ),
          Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 10,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
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
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ],
                      ),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    SizedBox(height: 75.0),
                    Text(
                      phone.toString(),
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 15.0),
                    // Text(
                    //   email.toString(),
                    //   style: TextStyle(
                    //       fontSize: 17.0,
                    //       fontStyle: FontStyle.italic,
                    //       fontFamily: 'Montserrat'),
                    // ),
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
                                        color: Colors.white,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(12.0, 0.0, 6.0, 0.0),
                                height: 40.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyOrders(user)));
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10.0),
                                    shadowColor: Colors.deepOrangeAccent,
                                    color: Colors.orange[400],
                                    elevation: 5.0,
                                    child: Center(
                                      child: Text(
                                        'My Orders',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.0),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(12.0, 0.0, 6.0, 0.0),
                                height: 40.0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _lOut = true;
                                    });
                                    logOut();
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10.0),
                                    shadowColor: Colors.redAccent,
                                    color: Colors.deepOrangeAccent,
                                    elevation: 5.0,
                                    child: _lOut
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Center(
                                            child: Text(
                                              'Log out',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat'),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 4));
    Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AuthPage()));
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
