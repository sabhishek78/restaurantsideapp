import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurantsideapp/add_menu_item.dart';
import 'package:restaurantsideapp/add_redeem_menu_item.dart';
import 'package:restaurantsideapp/details.dart';
import 'package:restaurantsideapp/grid_product.dart';
import 'package:restaurantsideapp/redeem_details.dart';


class RedeemMenuScreen extends StatefulWidget {
  RedeemMenuScreen({Key key}) : super(key: key);
  @override
  _RedeemMenuScreenState createState() => _RedeemMenuScreenState();
}

class _RedeemMenuScreenState extends State<RedeemMenuScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<Map> foods = [];
  bool isLoading = true;
  getRedeemMenu() {
    firestoreInstance.collection("redeemMenu").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        // print(result.data());
        foods.add(result.data());
      }
      );
      isLoading = false;
      setState(() {});
    }
    );
  }
  void initState() {
    super.initState();
    getRedeemMenu();
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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Redeem Menu Items",
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
          : Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child:  ListView.builder(
          shrinkWrap: true,
          itemCount: foods.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  leading: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('${foods[index]["image"]}')),
                  title: Text('${foods[index]["name"]}'),
                  trailing:Text("Points :${foods[index]["points"].toString()}"),
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context){
                          return RedeemProductDetails(foodItem: foods[index]);
                        },
                      ),
                    );
                  }
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context){
                return AddRedeemMenuItem();
              },
            ),
          );
        },
        label: Text('Add New Item'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

}
