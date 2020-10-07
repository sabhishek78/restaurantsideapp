import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurantsideapp/menu.dart';

class AddMenuItem extends StatefulWidget {
  final List<String> categories;

  AddMenuItem({Key key, @required this.categories}) : super(key: key);

  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  final TextEditingController _itemNameController = new TextEditingController();
  final TextEditingController _itemPriceController =
      new TextEditingController();
  final TextEditingController _categoryController =
  new TextEditingController();
  final TextEditingController _itemDescriptionController = new TextEditingController();
  List<String> categories = []; // Option 2
  String selectedCategory; // Option 2
  File _image;
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://restaurantapp-65d0e.appspot.com');
  StorageUploadTask _uploadTask;
  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    isLoading=false;
    super.initState();
    categories = widget.categories;
    if(!categories.contains("Add New Category")){
      categories.add("Add New Category");
    }

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
                      title: new Text('Librería fotográfica'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Cámara'),
                    onTap: () {
                      _imgFromCamera();
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
  uploadMenuItemToFirebase()async{
    String fileName = _itemNameController.text;
    fileName = fileName.trim();
     _uploadTask = _storage.ref().child(fileName).putFile(_image);
    String docUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    DocumentReference documentReference = FirebaseFirestore.instance.collection('menu').doc();

    await documentReference.set({
      "id":documentReference.id,
      "category": _categoryController.text,
      "description": _itemDescriptionController.text,
      "image": docUrl,
      "name":_itemNameController.text,
      "points":0,
      "price":int.parse(_itemPriceController.text),
      "redeem":false,
    });

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
            "Agregar elemento de menú",// Add Menu Item
          ),
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.cyan,
            strokeWidth: 5,
          ),
        )
            : SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                      hintText: "Nombre del árticulo",//Item Name
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.fastfood,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                    controller: _itemNameController,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
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
                    keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
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
                      hintText: "₲ Precio del articulo",//Item Price
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),

                    ),
                    maxLines: 1,
                    controller: _itemPriceController,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xffFDCF09),
                    child: _image != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        _image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "selecciona una categoría:",//Select Category
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              DropdownButton(
                hint: Text('Por favor elija una categoría'),//Please choose a Category
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
                      hintText: "Categoría",
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
              Text(
                "Ingrese la descripción del artículo",//Enter Item Description
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
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
                      hintText: "Enter Description",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),

                    ),
                    maxLines: 5,
                    controller: _itemDescriptionController,
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  "Salvar ",
                  style: TextStyle(
                     fontSize: 22,
                     fontWeight: FontWeight.w800,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onPressed: () async{
                  if(_image==null){
                    Fluttertoast.showToast(msg: "Please select Image");//Item Added To Cart
                  }
                  else if(_itemNameController.text==""){
                    Fluttertoast.showToast(msg: "Please enter Name");//Item Added To Cart
                  }
                  else if(_itemPriceController.text==""){
                    Fluttertoast.showToast(msg: "Please enter Price");//Item Added To Cart
                  }
                  else if(_itemDescriptionController.text==""){
                    Fluttertoast.showToast(msg: "Please enter Description");//Item Added To Cart
                  }
                  else if(_categoryController.text==""){
                    Fluttertoast.showToast(msg: "Please select Category");//Item Added To Cart
                  }
                  else{
                    isLoading=true;
                    setState(() {

                    });
                    await uploadMenuItemToFirebase();
                    // await alertDialogUploadFinished(context);
                    isLoading=false;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context){
                          return MenuScreen();
                        },
                      ),
                    );
                  }
                  },
              ),
            ],
          ),
        ));
  }
}
alertDialogUploadFinished(BuildContext context) async{
  // This is the ok button
  Widget ok = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // show the alert dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Subida finalizada"),//Upload Finished
        content: Text("Menú subido a Firebase"),//Menu Uploaded to Firebase
        actions: [
          ok,
        ],
        elevation: 5,
      );
    },
  );
}
