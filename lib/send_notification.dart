import 'dart:convert';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendNotificationScreen extends StatefulWidget {
  SendNotificationScreen({Key key}) : super(key: key);
  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController notificationController = new TextEditingController();
  List<Map> users=[];
  bool _isButtonDisabled=false;
  uploadNotificationToFirebase(text)async{
    _isButtonDisabled=true;
    setState(() {
    });
    DocumentReference documentReference = FirebaseFirestore.instance.collection('notification').doc("dwpLs97JleIhbpm9jqUY");
    await documentReference.set({
      "message":text
    });
    _isButtonDisabled=false;
    setState(() {
    });
    Fluttertoast.showToast(msg: "Notification Sent");//Item Added To Cart
    print("Notification Uploaded to Firebase");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: ()=>Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "Enviar notificación",
          ),
          elevation: 0.0,
          actions: <Widget>[
          ],
        ),
        body:Center(
          child: Card(
            child: Column(
              children: <Widget>[
                Text("Enviar notificación a todos los usuarios"),
                Card(
                  elevation: 3.0,
                  child: Container(
                    margin: EdgeInsets.all(12),
                    height: 5 * 24.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Texto de notificación",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),

                      ),
                      maxLines: 5,
                      controller: notificationController,
                    ),
                  ),
                ),
                FlatButton(
                  color: _isButtonDisabled?Colors.grey:Theme.of(context).accentColor,
                  child: Text(
                    "Enviar".toUpperCase(),//Send
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: ()async{
                    if(!_isButtonDisabled)
                      await uploadNotificationToFirebase(notificationController.text);
                    notificationController.clear();
                    get("https://us-central1-restaurantapp-65d0e.cloudfunctions.net/sendNotificationToAllUsers");

                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}

