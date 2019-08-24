import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/auth/auth_page.dart';

import '../app.dart';

class ProfileScreen extends StatefulWidget {
  // FirebaseUser user;
  // ProfileScreen(this.user);

  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser user;
  String phone = " Login To Continue ";
  String picUrl = "";
  bool _lOut = false;
  ProfileScreenState() {
    getUser();
  }

  Future getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    print(user);
    if (user != null) {
      phone = user.displayName.toString();
      picUrl = user.photoUrl.toString();
      print(phone);
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.teal),
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
                        color: Colors.red,
                        image: DecorationImage(
                            image: NetworkImage('$picUrl'), fit: BoxFit.contain),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ],
                      ),
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
                    Container(
                      height: 40.0,
                      width: 110.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.indigo,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {},
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
                      height: 40.0,
                      width: 110.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.redAccent,
                        color: Colors.deepOrange,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _lOut = true;
                            });
                            logOut();
                          },
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
