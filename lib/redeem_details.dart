import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurantsideapp/menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:restaurantsideapp/redeem_menu.dart';


class RedeemProductDetails extends StatefulWidget {
  final Map foodItem;
  final Function updateRedeemMenuScreenState;
  RedeemProductDetails({Key key, @required this.foodItem,@required this.updateRedeemMenuScreenState}) : super(key: key);
  @override
  _RedeemProductDetailsState createState() => _RedeemProductDetailsState();
}

class _RedeemProductDetailsState extends State<RedeemProductDetails> {
  File _image;
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://restaurantapp-65d0e.appspot.com');
  StorageUploadTask _uploadTask;
  Map foodItem=new Map();
  bool isLoading=true;

  deleteItemFromDatabase()async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('redeemMenu').doc(widget.foodItem["name"]);
    await documentReference.delete();
    print("item deleted from database");
  }
  uploadPhotoToFirebase()async{
    print("Uploading image to Firebase");
    String fileName =  widget.foodItem['name'];
    fileName = fileName.trim();
    _uploadTask = _storage.ref().child(fileName).putFile(_image);
    String docUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var menuRef = FirebaseFirestore.instance.collection("redeemMenu");
    var query = await menuRef.where("name", isEqualTo: foodItem['name']).get();
    var docSnapShotList = query.docs;
    var docName=docSnapShotList[0].id;
    print("Document Name="+docName);
    await menuRef.doc(docName).update({"image":docUrl});
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
                      title: new Text('Photo Library'),
                      onTap: () async{
                        await _imgFromGallery();
                        await uploadPhotoToFirebase();
                        await widget.updateRedeemMenuScreenState();
                        await getFoodItemDetails();
                        Navigator.of(context).pop();

                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async{
                      await _imgFromCamera();
                      await uploadPhotoToFirebase();
                      await widget.updateRedeemMenuScreenState();
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
    var menuRef = FirebaseFirestore.instance.collection("redeemMenu");
    var query = await menuRef.where("name", isEqualTo: widget.foodItem['name']).get();
    var docSnapShotList =query.docs;
    foodItem=docSnapShotList[0].data();
    print(foodItem);
    isLoading=false;
    setState(() {

    });
  }
  void initState() {
    super.initState();
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
          onPressed: ()=>Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Item Details",
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
          :Padding(
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

            Row(
              children: <Widget>[
                Text(
                  foodItem["name"],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  Text(
                    foodItem["points"].toString(),
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
                      await alertDialogEditDishPoints(context);
                       widget.updateRedeemMenuScreenState();
                      getFoodItemDetails();

                      // setState(() {
                      //
                      // });
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
                  "Product Description",
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
                     widget.updateRedeemMenuScreenState();
                    getFoodItemDetails();
                    // setState(() {
                    //
                    // });
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
              "DELETE ITEM FROM DATABASE",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            color: Theme.of(context).accentColor,
            onPressed: ()async{
              await alertDialogConfirmDelete(context);
               widget.updateRedeemMenuScreenState();
              setState(() {

              });

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
            title: Text('Edit Dish Description'),
            content: TextField(
              maxLines: 5,
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Enter New Description"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () async{
                  print("Updating Dish Description");
                  var menuRef = FirebaseFirestore.instance.collection("redeemMenu");
                  var query = await menuRef.where("name", isEqualTo:foodItem['name']).get();
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
  alertDialogEditDishPoints(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Dish Points'),
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Enter New Dish Points"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () async{
                  print("Updating Dish Points");
                  var menuRef = FirebaseFirestore.instance.collection("redeemMenu");
                  var query = await menuRef.where("name", isEqualTo: foodItem['name']).get();
                  var docSnapShotList = query.docs;
                  var docName=docSnapShotList[0].id;
                  print("Document Name="+docName);
                  await menuRef.doc(docName).update({"points":int.parse(_textFieldController.text)});
                  Navigator.of(context).pop();

                  setState(() {

                  });
                  print("Dish Points Updated");

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
            title: Text('Delete Item from Database?'),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return RedeemMenuScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}
