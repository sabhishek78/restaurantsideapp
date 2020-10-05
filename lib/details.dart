import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurantsideapp/menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';


class ProductDetails extends StatefulWidget {
  final Map foodItem;
  final Function updateMenuScreenState;
  final List<String> categories;
  ProductDetails({Key key, @required this.foodItem,@required this.updateMenuScreenState,@required this.categories}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  File _image;
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://restaurantapp-65d0e.appspot.com');
  StorageUploadTask _uploadTask;
  Map foodItem=new Map();
  bool isLoading;
  List<String> categories = []; // Option 2
  String selectedCategory; // Option 2
  final TextEditingController _categoryController =
  new TextEditingController();

  deleteItemFromDatabase()async{
    print("food item id");
    print(widget.foodItem["id"]);
    DocumentReference documentReference = FirebaseFirestore.instance.collection('menu').doc(widget.foodItem["id"]);
    await documentReference.delete();
    widget.updateMenuScreenState();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return MenuScreen();
        },
      ),
    );
    print("item deleted from database");
  }
  uploadPhotoToFirebase()async{
    print("Uploading image to Firebase");
    String fileName =  widget.foodItem['name'];
    fileName = fileName.trim();
    _uploadTask = _storage.ref().child(fileName).putFile(_image);
    String docUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var menuRef = FirebaseFirestore.instance.collection("menu");
    var query = await menuRef.where("id", isEqualTo: widget.foodItem['id']).get();
    var docSnapShotList = query.docs;
     var docName=docSnapShotList[0].id;
     print("Document Name="+docName);
     await menuRef.doc(docName).update({"image":docUrl});
    setState(() {

    });
    print("Uploaded image to firebase");
  }
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Librería fotográfica'),//Photo Library
                      onTap: () async{
                       await _imgFromGallery();
                       await uploadPhotoToFirebase();
                       await widget.updateMenuScreenState();
                       await getFoodItemDetails();
                       Navigator.of(context).pop();

                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Cámara'),//Camera
                    onTap: () async{
                     await _imgFromCamera();
                     await uploadPhotoToFirebase();
                     await widget.updateMenuScreenState();
                     await getFoodItemDetails();
                     Navigator.of(context).pop();
                     },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  getFoodItemDetails()async{
    print("fetching food item details from Firebase");
    var menuRef = FirebaseFirestore.instance.collection("menu");
    var query = await menuRef.where("id", isEqualTo: widget.foodItem['id']).get();
    var docSnapShotList =query.docs;
    foodItem=docSnapShotList[0].data();
    print(foodItem);
    isLoading=false;
    setState(() {

    });
  }
  void initState() {
    super.initState();
    isLoading=true;
    categories = widget.categories;
    if(!categories.contains("Add New Category")){
      categories.add("Add New Category");
    }
    getFoodItemDetails();
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
          onPressed: (){
            widget.updateMenuScreenState();
            Navigator.pop(context);
          }
        ),
        centerTitle: true,
        title: Text(
          "detalles del artículo",//Item Details
        ),
        elevation: 0.0,
        actions: <Widget>[
          ],
      ),

      body:isLoading
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan,
          strokeWidth: 5,
        ),
      )
          : Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      foodItem['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: -10.0,
                  bottom: 3.0,
                  child: RawMaterialButton(
                    onPressed: (){
                      _showPicker(context);
                    },
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.update,
                        color: Colors.red,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  Text(
                    foodItem["name"],
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20.0,
                    ),
                    onPressed: ()async {
                      await alertDialogEditDishName(context);
                      await widget.updateMenuScreenState();
                      await getFoodItemDetails();

                    },
                    tooltip: "Edit",
                  )

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "₲ "+foodItem["price"].toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20.0,
                    ),
                    onPressed: ()async {
                      await alertDialogEditDishPrice(context);
                      await widget.updateMenuScreenState();
                      await getFoodItemDetails();

                    },
                    tooltip: "Edit",
                  )

                ],
              ),
            ),


            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            Card(
              elevation: 3.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextField(
                  enabled: _categoryController.text=="Add New Category"?true:false,
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
                    hintText: foodItem["category"],
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.category,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  controller: _categoryController,
                ),
              ),
            ),
            DropdownButton(
              hint: Text('Cambiar categoría'),//Please choose a Category
              // Not necessary for Option 1
              value: selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                  _categoryController.text=selectedCategory;
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem(
                  child: new Text(category),
                  value: category,
                );
              }).toList(),
            ),
            FlatButton(
              child: Text('Categoría de actualización'),
              color: Colors.blue,
                onPressed: () async{
                  print("Updating Dish Category");
                  var menuRef = FirebaseFirestore.instance.collection("menu");
                  var query = await menuRef.where("id", isEqualTo: foodItem['id']).get();
                  var docSnapShotList = query.docs;
                  var docName=docSnapShotList[0].id;
                  print("Document Name="+docName);
                  await menuRef.doc(docName).update({"category":_categoryController.text});
                  setState(() {

                  });
                  print("Dish Category Updated");
                  Fluttertoast.showToast(msg: "Categoría de plato actualizada");//Item Added To Cart

                },
            ),
            Row(
              children: <Widget>[
                Text(
                  "Descripción del producto",//Product Description
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20.0,
                  ),
                  onPressed: ()async {
                    await alertDialogEditDishDescription(context);
                    await widget.updateMenuScreenState();
                    await getFoodItemDetails();

                  },
                  tooltip: "Edit",
                )
              ],
            ),

            SizedBox(height: 10.0),

            Text(
              foodItem["description"],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
              child: Text(
                "BORRAR ELEMENTO DE LA BASE DE DATOS",//DELETE ITEM FROM DATABASE
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Theme.of(context).accentColor,
              onPressed: ()async{
                await alertDialogConfirmDelete(context);
                await widget.updateMenuScreenState();


                 },
            )

      ),
    );
  }
  alertDialogEditDishDescription(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar descripción del plato'),//Edit Dish Description
            content: TextField(
              maxLines: 5,
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Ingrese nueva descripción"),//Enter New Description
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () async{
                  print("Updating Dish Description");
                  var menuRef = FirebaseFirestore.instance.collection("menu");
                  var query = await menuRef.where("id", isEqualTo: foodItem['id']).get();
                  var docSnapShotList = query.docs;
                  var docName=docSnapShotList[0].id;
                  print("Document Name="+docName);
                  await menuRef.doc(docName).update({"description":_textFieldController.text});
                  Navigator.of(context).pop();
                  setState(() {

                  });
                  print("Dish Description Updated");

                },
              )
            ],
          );
        });
  }
  alertDialogEditDishPrice(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar precio del plato'),//Edit Dish Price
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Ingrese el nuevo precio del plato"),//Enter New Dish Price
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Enviar'),
                onPressed: () async{
                  print("Updating Dish Price");//
                  var menuRef = FirebaseFirestore.instance.collection("menu");
                  var query = await menuRef.where("id", isEqualTo: foodItem['id']).get();
                  var docSnapShotList = query.docs;
                  var docName=docSnapShotList[0].id;
                  print("Document Name="+docName);
                  await menuRef.doc(docName).update({"price":int.parse(_textFieldController.text)});
                  Navigator.of(context).pop();
                  setState(() {

                  });
                  print("Dish Price Updated");

                },
              )
            ],
          );
        });
  }
  alertDialogEditDishName(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Dish Name'),//Edit Dish Name
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Enter New Dish Name"),//Enter New Dish Price
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Enviar'),
                onPressed: () async{
                  print("Updating Dish Name");//
                  var menuRef = FirebaseFirestore.instance.collection("menu");
                  var query = await menuRef.where("id", isEqualTo: foodItem['id']).get();
                  var docSnapShotList = query.docs;
                  var docName=docSnapShotList[0].id;
                  print("Document Name="+docName);
                  await menuRef.doc(docName).update({"name":int.parse(_textFieldController.text)});
                  Navigator.of(context).pop();
                  setState(() {

                  });
                  print("Dish Name Updated");

                },
              )
            ],
          );
        });
  }
  alertDialogConfirmDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('¿Eliminar elemento de la base de datos?'),//Delete Item from Database?
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () async{
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () async{
                  await deleteItemFromDatabase();

                  },
              ),
            ],
          );
        });
  }
}
