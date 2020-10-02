import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PendingOrdersScreen extends StatefulWidget {
  PendingOrdersScreen({Key key}) : super(key: key);

  @override
  _PendingOrdersScreenState createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String restaurantId = "";
  List<Map> orders = [];
  bool isLoading=true;

  fetchOrders() async {
    var staffRef = FirebaseFirestore.instance.collection("staff");
    var query = await staffRef.where("id", isEqualTo: user.email).get();
    var docSnapShotList = query.docs;
    restaurantId = docSnapShotList[0].get("restaurantId");
    print(restaurantId);
    var ordersRef = FirebaseFirestore.instance.collection("orders");
    var query2 = await ordersRef
        .where("restaurantId", isEqualTo: restaurantId)
        .where("status", isEqualTo: "placed")
        .get();
    var orderSnapShotList = query2.docs;
    print("order snapshotlist");
    print(orderSnapShotList);
    for (int i = 0; i < orderSnapShotList.length; i++) {
      Map temp = orderSnapShotList[i].data();
      orders.add(temp);
    }
    print(orders);
    isLoading=false;
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
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
          "ORDENES PENDIENTES",// PENDING ORDERS
        ),
        elevation: 0.0,
        actions: <Widget>[

        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan,
          strokeWidth: 5,
        ),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color:Colors.blue[100],
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: List.generate(orders[index]["order"].length, (i) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Name :"+orders[index]["order"][i]["name"],
                                      style: TextStyle(color: Colors.black)),
                                  Text("Quantity :"+orders[index]["order"][i]["quantity"].toString(),
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      ),
                    ),
                    Text("Time:"+orders[index]["timestamp"],
                        style: TextStyle(color: Colors.red,)),
                    Text("UserId:"+orders[index]["userId"],
                        style: TextStyle(color: Colors.blue,)),
                    Text("PaymentMode:"+orders[index]["paymentMode"],
                        style: TextStyle(color: Colors.green)),
                    Text("Total:"+orders[index]["total"].toString(),
                        style: TextStyle(color: Colors.black)),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(5,5,10,5),
                          width: 150.0,
                          height: 50.0,
                          child: FlatButton(
                            color: Colors.green,
                            child: Text(
                              "Aceptar orden".toUpperCase(),//Accept Order
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: ()async{
                              DocumentReference documentReference = FirebaseFirestore.instance.collection('orders').doc(orders[index]["orderId"]);
                              await documentReference.update({
                                "status":"accepted",
                              });
                              orders = [];
                              fetchOrders();
                              setState(() {

                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5,5,10,5),
                          width: 150.0,
                          height: 50.0,
                          child: FlatButton(
                            color: Colors.red,
                            child: Text(
                              "Rechazar orden".toUpperCase(),//Reject Order
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: ()async{
                              DocumentReference documentReference = FirebaseFirestore.instance.collection('orders').doc(orders[index]["orderId"]);
                              await documentReference.update({
                                "status":"rejected",
                              });
                              orders = [];
                              fetchOrders();
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
