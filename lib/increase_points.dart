import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IncreasePointsScreen extends StatefulWidget {
  IncreasePointsScreen({Key key}) : super(key: key);
  @override
  _IncreasePointsScreenState createState() => _IncreasePointsScreenState();
}

class _IncreasePointsScreenState extends State<IncreasePointsScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController pointsController = new TextEditingController();
  List<Map> users=[];
  bool _isButtonDisabled=false;
  increasePointsOfAllUsers(increment) async {
      _isButtonDisabled=true;
      setState(() {
      });
      print("incrementing points");
      firestoreInstance.collection("users").get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async{
          var points=doc.data()["points"];
          print(doc.id);
          print("current points=$points");
          await firestoreInstance.collection("users").doc(doc.id).update({"points":points+increment});
          print("points incremented");
          _isButtonDisabled=false;
          setState(() {
          });
          Fluttertoast.showToast(msg: "Se han incrementado los puntos de todos los usuarios.");//Item Added To Cart
        }
        );
      });
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
          "Aumentar puntos",//Increase Points
        ),
        elevation: 0.0,
        actions: <Widget>[
          ],
      ),
      body:Center(
        child: Card(
                child: Column(
                  children: <Widget>[
                    Text("Increase points of All Users By"),
                    TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.blue,),
                        ),
                        hintText: "Points",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),

                      controller: pointsController,
                    ),
                    FlatButton(
                      color: _isButtonDisabled?Colors.grey:Theme.of(context).accentColor,
                      child: Text(
                        "Aumentar puntos".toUpperCase(),//Place Order
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: ()async{
                        if(!_isButtonDisabled)
                           await increasePointsOfAllUsers(int.parse(pointsController.text));
                          pointsController.clear();
                         },
                    ),
                  ],
                ),
        ),
      )
    );
  }
}

