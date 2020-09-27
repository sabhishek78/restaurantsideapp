import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurantsideapp/add_menu_item.dart';
import 'package:restaurantsideapp/grid_product.dart';


class MenuScreen extends StatefulWidget {

  MenuScreen({Key key}) : super(key: key);
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final firestoreInstance = FirebaseFirestore.instance;

  List<Map> foods = [];

  List<String> categories = [];
  bool isLoading = true;
  getMenu() {
    firestoreInstance.collection("menu").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          // print(result.data());
          foods.add(result.data());
        }
        );
        categories = getCategories(foods);
        isLoading = false;
        setState(() {});
      }
      );
  }
  void initState() {
    super.initState();
    getMenu();
  }
  updateMenuScreenState(){
    getMenu();
    setState(() {

    });
  }
  getCategories(List<Map<dynamic, dynamic>> foods) {
    List<String> categories = [];
    for (var i = 0; i < foods.length; i++) {
      foods[i].forEach((k, v) {
        if (k == 'category') {
          if (!categories.contains(v)) {
            categories.add(v);
          }
        }
      });
    }
    // print("List of Categories:");
    categories.sort();
    // print(categories);
    return categories;
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
          "Menu Items",
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
        child: ListView(
          children: generateFoodItems(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context){
                return AddMenuItem(categories:categories);
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

  List<Widget> generateFoodItems() {

    List<Widget> children = [];
    for (int i = 0; i < categories.length; i++) {
      children.add(Text(
        categories[i],
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        maxLines: 2,
      ));
      children.add(Divider());
      List temp = foods
          .where((food) => food["category"] == categories[i])
          .toList();
      children.add(
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.25),
          ),
          itemCount: temp.length,
          itemBuilder: (BuildContext context, int index) {
            Map food = temp[index];
            // print(food);
            return GridProduct(
              updateMenuScreenState:updateMenuScreenState,
              food:food,
              img: food['image'],
              // isFav: false,
              name: food['name'],
              // rating: 5.0,
              // raters: 23,
            );
          },
        ),
      );
    }
    return children;
  }
}
