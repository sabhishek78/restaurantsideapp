import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantsideapp/accepted_orders.dart';
import 'package:restaurantsideapp/delivered_orders.dart';
import 'package:restaurantsideapp/menu.dart';
import 'package:restaurantsideapp/out_for_delivery.dart';
import 'package:restaurantsideapp/pending_orders.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String workStatus="";
  getWorkStatus()async{
    var staffRef = FirebaseFirestore.instance.collection("staff");
    var query = await staffRef.where("id", isEqualTo: user.email).get();
    var docSnapShotList = query.docs;
    workStatus = docSnapShotList[0].get("status");
    print(workStatus);
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWorkStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "ORDERS PAGE",
        ),
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(5,5,10,5),
              width: 150.0,
              height: 50.0,
              child: FlatButton(
                color: Colors.red,
                child: Text(
                  "PENDING ORDERS".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return PendingOrdersScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5,5,10,5),
              width: 150.0,
              height: 50.0,
              child: FlatButton(
                color: Colors.green,
                child: Text(
                  "ACCEPTED ORDERS".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return AcceptedOrdersScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5,5,10,5),
              width: 150.0,
              height: 50.0,
              child: FlatButton(
                color: Colors.yellow,
                child: Text(
                  "OUT FOR DELIVERY".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return OutForDeliveryScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5,5,10,5),
              width: 150.0,
              height: 50.0,
              child: FlatButton(
                color: Colors.blue,
                child: Text(
                  "DELIVERED".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return DeliveredOrdersScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            if(workStatus=="manager")
              Container(
                padding: EdgeInsets.fromLTRB(5,5,10,5),
                width: 150.0,
                height: 50.0,
                child: FlatButton(
                  color: Colors.red,
                  child: Text(
                    "View/Change Menu".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context){
                          return MenuScreen();
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
