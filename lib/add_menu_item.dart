import 'package:flutter/material.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = widget.categories;
    categories.add("Add New Category");
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
            "Add Menu Item",
          ),
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: SingleChildScrollView(
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
                      hintText: "Item Name",
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
                      hintText: "Item Price",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                    controller: _itemPriceController,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Select Category:",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              DropdownButton(
                hint: Text('Please choose a Category'),
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
                      hintText: "Category",
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
                "Enter Item Description",
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
                  "Save ",
                  style: TextStyle(
                     fontSize: 22,
                     fontWeight: FontWeight.w800,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onPressed: () {

                },
              ),
            ],
          ),
        ));
  }
}
