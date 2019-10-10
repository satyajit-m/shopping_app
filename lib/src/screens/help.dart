import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../size_config.dart';

class HelpScreen extends StatefulWidget {
  HelpScreen({Key key}) : super(key: key);

  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int _taps = 0;

  _HelpScreenState() {
    _taps = 0;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.deepOrange[300]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Card(
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[100],
                    ),
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Image.asset(
                          "assets/images/logo.png",
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onTap: () {
                        if (_taps < 10) {
                          _taps += 1;
                          return;
                        }
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => MG(),
                          ),
                        )
                            .then((val) {
                          _taps = 0;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(color: Colors.deepOrange[400]),
                  child: Card(
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "Contact Us",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "1234567890",
                          style: TextStyle(fontSize: 16),
                        ),
                        InkWell(
                          onTap: () => _launchCaller("1234567890"),
                          child: Container(
                            padding: EdgeInsets.all(3),
                            child: Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
}
