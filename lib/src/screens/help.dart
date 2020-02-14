import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../size_config.dart';

class HelpScreen extends StatefulWidget {
  HelpScreen({Key key}) : super(key: key);

  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int _taps = 0;
  double ht, wd;

  _HelpScreenState() {
    _taps = 0;
  }

  Widget build(BuildContext context) {
    ht = MediaQuery.of(context).size.height;
    wd = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(ht * 0.05,ht * 0.05,ht * 0.05,0),
        width: wd,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepOrange[100], Colors.deepOrange[50]],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'Just A Moment !',
                style: TextStyle(
                    fontSize: ht * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[500],
                    fontFamily: "Roboto"),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, ht * 0.03, 0.0, 0.0),
              child: Text(
                'Why waste time ?',
                style: TextStyle(fontSize: ht * 0.034),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, ht * 0.03, 0.0, 0.0),
              child: Text(
                "We're just a Click away",
                style: TextStyle(
                    fontSize: ht * 0.035, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, ht * 0.03, 0.0, 0.0),
              child: Text(
                "Sit back & Relax",
                style: TextStyle(fontSize: ht * 0.034),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, ht * 0.05, 0.0, 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: new Container(
                        height: ht * 0.1,
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.contain,
                                image: new NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/fixr-3b596.appspot.com/o/cliparts%2Fhouse_renovation%2Fpainter%2F2.png?alt=media&token=cb28e0b2-c77b-4c96-a919-29c1d34bec9d")))),
                  ),
                  Expanded(
                    child: Container(
                        height: ht * 0.1,
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.contain,
                                image: new NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/fixr-3b596.appspot.com/o/cliparts%2Fcleaning%2F3.png?alt=media&token=6855982d-d47c-4017-bcd9-5aa0a52df00a")))),
                  ),
                  Expanded(
                    child: Container(
                        height: ht * 0.1,
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.contain,
                                image: new NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/fixr-3b596.appspot.com/o/cliparts%2Fevent_management%2Fparty%26event%2F6.png?alt=media&token=2adbf0b0-b784-46d1-93ae-d1c05002fd25")))),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, ht * 0.1, 0.0, 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Write To Us ',
                      style: TextStyle(fontSize: ht * 0.04),
                    ),
                  ),
                  Expanded(
                    child: AvatarGlow(
                      endRadius: ht * 0.06,
                      startDelay: Duration(milliseconds: 1000),
                      glowColor: Colors.deepOrange,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      repeatPauseDuration:
                          Duration(milliseconds: 100), //required
                      child: Material(
                        //required
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: IconButton(
                            icon: Icon(Icons.email),
                            color: Colors.orange,
                            iconSize: ht * 0.04,
                            onPressed: (){
                              _launchEmail("fixrglobal@gmail.com");
                            },
                          ),
                          radius: ht * 0.035,
                        ),
                      ),
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, ht * 0.01, 0.0, 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1,
                    child: AvatarGlow(
                      endRadius: ht * 0.07,
                      startDelay: Duration(milliseconds: 1000),
                      glowColor: Colors.deepOrange,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      repeatPauseDuration:
                          Duration(milliseconds: 100), //required
                      child: Material(
                        //required
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child:  IconButton(
                            icon: Icon(Icons.phone),
                            color: Colors.orange,
                            iconSize: ht * 0.04,
                            onPressed: (){
                              _launchCaller("+916370971229");
                            },
                          ),
                          radius: ht * 0.035,
                        ),
                      ),
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  Expanded(flex: 2,
                    child: Text(
                      'Call Us ',
                      style: TextStyle(fontSize: ht * 0.04),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchCaller(String url) async {
    if (await canLaunch("tel:" + url)) {
      await launch("tel:" + url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail(String url) async {
    if (await canLaunch("mailto:" + url + "?subject=&body="  )) {
      await launch("mailto:" + url + "?subject=Assistance Required&body=");
    } else {
      throw 'Could not launch $url';
    }
  }
}
