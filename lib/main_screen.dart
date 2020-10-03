import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantsideapp/accepted_orders.dart';
import 'package:restaurantsideapp/change_delivery_charge.dart';
import 'package:restaurantsideapp/increase_points.dart';
import 'package:restaurantsideapp/main.dart';
import 'package:restaurantsideapp/orders_by_restaurant.dart';
import 'package:restaurantsideapp/all_orders_owner.dart';
import 'package:restaurantsideapp/delivered_orders.dart';
import 'package:restaurantsideapp/menu.dart';
import 'package:restaurantsideapp/out_for_delivery.dart';
import 'package:restaurantsideapp/pending_orders.dart';
import 'package:restaurantsideapp/redeem_menu.dart';

class MainScreen extends StatefulWidget {
  final List<String> categories;
  MainScreen({Key key, @required this.categories}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String workStatus="";
  bool isLoading;

  getWorkStatus()async{
    var staffRef = FirebaseFirestore.instance.collection("staff");
    var query = await staffRef.where("id", isEqualTo: user.email).get();
    var docSnapShotList = query.docs;
    workStatus = docSnapShotList[0].get("status");
    print(workStatus);
    isLoading=false;
    setState(() {

    });
  }
  @override
  void initState() {
    isLoading=true;
    // TODO: implement initState
    super.initState();
    getWorkStatus();
  }
  signOut() async {
    await auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Página de pedidos",//ORDERS PAGE
        ),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            color: Colors.blue,
            label: Text('Cerrar sesión'),//LogOut
            icon: Icon(Icons.power_settings_new),
            onPressed: (){
              signOut();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return MyHomePage();
                  },
                ),
              );
            },
          )
        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan,
          strokeWidth: 5,
        ),
      )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if(workStatus=="manager" || workStatus=="worker")
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.red,
                    child: Text(
                      "Ordenes pendientes".toUpperCase(),//PENDING ORDERS
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
              if(workStatus=="manager" || workStatus=="worker")
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.green,
                  child: Text(
                    "PEDIDOS ACEPTADOS".toUpperCase(),//ACCEPTED ORDERS
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
              if(workStatus=="manager" || workStatus=="worker")
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.yellow,
                  child: Text(
                    "Fuera para entrega".toUpperCase(),// Out for Delivery
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
              if(workStatus=="manager" || workStatus=="worker")
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.blue,
                  child: Text(
                    "ENTREGADO".toUpperCase(),//DELIVERED
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
              if(workStatus=="manager" || workStatus=="owner")
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.red,
                    child: Text(
                      "Menú Ver / Cambiar".toUpperCase(),//View/Change Menu
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
              if(workStatus=="manager" || workStatus=="owner")
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.red,
                    child: Text(
                      "Ver / Cambiar menú de canje".toUpperCase(),//View/Change Redeem Menu
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return RedeemMenuScreen();
                          },
                        ),
                      );
                    },
                  ),
                ),
              if(workStatus=="manager")
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.red,
                    child: Text(
                      "cambiar gastos de envío".toUpperCase(),//Change delivery Charge
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return ChangeDeliveryChargeScreen();
                          },
                        ),
                      );
                    },
                  ),
                ),
              if(workStatus=="manager")
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.red,
                    child: Text(
                      "Ver historial de pedidos".toUpperCase(),//View Order History
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return OrdersByRestaurantScreen();
                          },
                        ),
                      );
                    },
                  ),
                ),
              if(workStatus=="owner")
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.red,
                    child: Text(
                      "Ver historial de pedidos".toUpperCase(),// View Order History
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return AllOrdersOwnerScreen();
                          },
                        ),
                      );
                    },
                  ),
                ),
              if(workStatus=="owner")
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.red,
                    child: Text(
                      "Aumentar puntos".toUpperCase(),// Increase Points
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return IncreasePointsScreen();
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
        ),
      ),
          ),
    );
  }
}
