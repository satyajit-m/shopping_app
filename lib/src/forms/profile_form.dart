import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileForm extends StatefulWidget {
  ProfileFormState createState() {
    return ProfileFormState();
  }
}

class ProfileFormState extends State<ProfileForm> {

  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode areaAndStreetFocus = FocusNode();
  FocusNode landmarkFocus = FocusNode();
  FocusNode altPhoneFocus = FocusNode();

  FirebaseUser currentUser;
  bool dataloaded = false;

  List<String> localityList = [];
  List<String> pinList = [];

  final formKey = GlobalKey<FormState>();

  int index = 0;

  var name;
  var phone;
  var pinCode;
  var areaAndStreet;
  var locality;
  var landmark;
  var altPhone;

  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (dataloaded) {
      return getForm();
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget getForm() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Center(
            child: Text("Profile"),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  nameField(context),
                  SizedBox(height: 20),
                  phoneField(context),
                  SizedBox(height: 20),
                  altPhoneFiled(context),
                  SizedBox(height: 20),
                  areaAndStreetField(context),
                  SizedBox(height: 20),
                  localitySelector(),
                  SizedBox(height: 20),
                  landmarkField(context),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      child: Text("Save"),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          Profile transactionData = Profile(this.name, this.phone, this.pinCode, this.areaAndStreet, this.locality, this.landmark, altPhone);
                          var transactionMap = profileTransaction(transactionData);
                          DocumentReference user = Firestore.instance.collection("users").document(currentUser.uid);
                          Firestore.instance.runTransaction((transaction) async {
                            await transaction.update(user, transactionMap);
                          });
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField nameField(BuildContext context) {
    return TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(30)],
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      focusNode: nameFocus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(phoneFocus);
      },
      decoration: InputDecoration(
        hintText: "Your Name",
        labelText: "Name",
        icon: Icon(Icons.people),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(),
          borderSide: BorderSide(),
        ),
      ),
      validator: (value) {
        if (value.length > 1) {
          return null;
        } else {
          return 'Please input valid Name';
        }
      },
      onSaved: (value) {
        name = value;
      },
    );
  }

  TextFormField phoneField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      textInputAction: TextInputAction.next,
      focusNode: phoneFocus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(altPhoneFocus);
      },
      decoration: InputDecoration(
        hintText: "10 Digit Phone Number",
        labelText: "Phone",
        icon: Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(),
          borderSide: BorderSide(),
        ),
      ),
      validator: (value) {
        if (value.length == 10) {
          return null;
        }
        return "Should be a 10 digit phone number";
      },
      onSaved: (value) {
        phone = value;
      },
    );
  }

  TextFormField altPhoneFiled(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      textInputAction: TextInputAction.next,
      focusNode: altPhoneFocus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(areaAndStreetFocus);
      },
      decoration: InputDecoration(
        hintText: "10 Digit Phone Number",
        labelText: "Alternate Phone Number",
        icon: Icon(Icons.call_missed),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(),
          borderSide: BorderSide(),
        ),
      ),
      validator: (value) {
        if (value.length == 10) {
          return null;
        }
        return "Should be a 10 digit phone number";
      },
      onSaved: (value) {
        altPhone = value;
      },
    );
  }

  TextFormField areaAndStreetField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      focusNode: areaAndStreetFocus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(landmarkFocus);
      },
      decoration: InputDecoration(
        hintText: "Xavier Road, Rail Vihar",
        labelText: "Address",
        icon: Icon(Icons.my_location),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(),
          borderSide: BorderSide(),
        ),
      ),
      validator: (value) {
        if (value.length > 10) {
          return null;
        }
        return "Please add more details";
      },
      onSaved: (value) {
        areaAndStreet = value;
      },
    );
  }

  DropdownButtonFormField localitySelector() {
    return DropdownButtonFormField(
      hint: Text('Locality'),
      value: localityList[index],
      items: localityList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          index = localityList.indexOf(value);
        });
      },
      onSaved: (value) {
        locality = localityList[index];
        pinCode = pinList[index];
      },
      decoration: InputDecoration(
        hintText: "Select a locality",
        labelText: "Locality",
        icon: Icon(Icons.fiber_pin),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(),
          borderSide: BorderSide(),
        ),
      ),
    );
  }

  TextFormField landmarkField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      focusNode: landmarkFocus,
      decoration: InputDecoration(
        hintText: "Near Jagannath M",
        labelText: "Landmark (optional)",
        icon: Icon(Icons.business),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(),
          borderSide: BorderSide(),
        ),
      ),
      onSaved: (value) {
        if (value == null) {
          landmark = "";
        } else {
          landmark = value;
        }
      },
    );
  }

  void loadData() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('ServArea').getDocuments();
    List<DocumentSnapshot> documents = result.documents;
    for (int i = 0; i < documents.length; i++) {
      localityList.add(documents[i].documentID);
      pinList.add(documents[i].data["pin"].toString());
    }
    currentUser = await FirebaseAuth.instance.currentUser();

    setState(() {
      dataloaded = true;
    });
  }
}
