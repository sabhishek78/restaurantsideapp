import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeDeliveryChargeScreen extends StatefulWidget {
  ChangeDeliveryChargeScreen({Key key}) : super(key: key);
  @override
  _ChangeDeliveryChargeScreenState createState() => _ChangeDeliveryChargeScreenState();
}

class _ChangeDeliveryChargeScreenState extends State<ChangeDeliveryChargeScreen> {
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String restaurantId = "";
  int deliveryCharge;
  final TextEditingController deliveryChargeController = new TextEditingController();
  bool _isButtonDisabled=false;
  getCurrentDeliveryChargeAndRestaurantId()async{
    var staffRef = FirebaseFirestore.instance.collection("staff");
    var query = await staffRef.where("id", isEqualTo: user.email).get();
    var docSnapShotList = query.docs;
    restaurantId = docSnapShotList[0].get("restaurantId");
    print(restaurantId);
    var query2 = await FirebaseFirestore.instance.collection("restaurants").doc(restaurantId).get();
    deliveryCharge = query2.data()["deliveryCharge"];

    print("delivery Charge=$deliveryCharge");
    setState(() {

    });

  }
  changeDeliveryCharge(newDeliveryCharge) async {
    _isButtonDisabled=true;
    setState(() {
    });
    print("updating delivery charge");
    await firestoreInstance.collection("restaurants").doc(restaurantId).update({"deliveryCharge":newDeliveryCharge});
    print("delivery Charge changed");
    _isButtonDisabled=false;
    getCurrentDeliveryChargeAndRestaurantId();
    setState(() {
    });
    Fluttertoast.showToast(msg: "Delivery Charge Updated");//Item Added To Cart

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDeliveryChargeAndRestaurantId();
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
            "cambiar gastos de envío",//Change delivery charge
          ),
          elevation: 0.0,
          actions: <Widget>[
          ],
        ),
        body:Center(
          child: Card(
            child: Column(
              children: <Widget>[
                Text("Cargo de entrega actual"),//Current Delivery Charge
                Text("$deliveryCharge"),
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
                    hintText: "Nuevo cargo por envío",//New Delivery Charge
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),

                  controller: deliveryChargeController,
                ),
                FlatButton(
                  color: _isButtonDisabled?Colors.grey:Theme.of(context).accentColor,
                  child: Text(
                    "Cambiar los gastos de envío".toUpperCase(),//Change Delivery Charge
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: ()async{
                    if(!_isButtonDisabled)
                      await changeDeliveryCharge(int.parse(deliveryChargeController.text));
                    deliveryChargeController.clear();
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}

