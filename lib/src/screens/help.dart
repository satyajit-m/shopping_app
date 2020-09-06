import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shopping_app/constants/color_const.dart';
import 'package:url_launcher/url_launcher.dart';

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
        padding: EdgeInsets.fromLTRB(ht * 0.05, ht * 0.05, ht * 0.05, 0),
        width: wd,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [iconBack, catColor, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    'Just A Moment !',
                    style: TextStyle(
                        fontSize: ht * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
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
                  margin: EdgeInsets.fromLTRB(0.0, ht * 0.01, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'Write To Us ',
                          ),
                        ),
                      ),
                      Expanded(
                        child: AvatarGlow(
                          endRadius: ht * 0.06,

                          startDelay: Duration(milliseconds: 1000),

                          glowColor: Colors.blue,

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
                                iconSize: ht * 0.04,
                                onPressed: () {
                                  _launchEmail("care@fixr.in");
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
                      Expanded(
                        flex: 1,
                        child: AvatarGlow(
                          endRadius: ht * 0.07,

                          startDelay: Duration(milliseconds: 1000),

                          glowColor: Colors.purple,

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
                                icon: Icon(Icons.phone),
                                color: Colors.purple,
                                iconSize: ht * 0.04,
                                onPressed: () {
                                  _launchCaller("+919090022001");
                                },
                              ),
                              radius: ht * 0.035,
                            ),
                          ),

                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: ht * 0.04,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              'Call Us ',
                              style: TextStyle(fontSize: ht * 0.04),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, ht * 0.01, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: ht * 0.04,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              'Message Us ',
                              style: TextStyle(fontSize: ht * 0.04),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AvatarGlow(
                          endRadius: ht * 0.07,

                          startDelay: Duration(milliseconds: 1000),

                          glowColor: Colors.green,

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
                                icon: Icon(LineIcons.whatsapp),
                                color: Colors.green[500],
                                iconSize: ht * 0.04,
                                onPressed: () {
                                  FlutterOpenWhatsapp.sendSingleMessage(
                                      "919090022001", 'Hello');
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
              ],
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
    if (await canLaunch("mailto:" + url + "?subject=&body=")) {
      await launch("mailto:" + url + "?subject=Assistance Required&body=");
    } else {
      throw 'Could not launch $url';
    }
  }
}
