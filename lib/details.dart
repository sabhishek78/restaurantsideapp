import 'package:flutter/material.dart';


class ProductDetails extends StatefulWidget {
  final Map foodItem;
  ProductDetails({Key key, @required this.foodItem}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // PageController _pageController;
  // int _page = 0;
  // bool isFav = false;
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

      body: Padding(
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
                      widget.foodItem['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Positioned(
                //   right: -10.0,
                //   bottom: 3.0,
                //   child: RawMaterialButton(
                //     onPressed: (){},
                //     fillColor: Colors.white,
                //     shape: CircleBorder(),
                //     elevation: 4.0,
                //     child: Padding(
                //       padding: EdgeInsets.all(5),
                //       child: Icon(
                //         isFav
                //             ?Icons.favorite
                //             :Icons.favorite_border,
                //         color: Colors.red,
                //         size: 17,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),

            SizedBox(height: 10.0),

            Text(
              widget.foodItem["name"],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "\$ "+widget.foodItem["price"].toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).accentColor,
                    ),
                  ),

                ],
              ),
            ),


            SizedBox(height: 20.0),

            Text(
              "Product Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),

            SizedBox(height: 10.0),

            Text(
              widget.foodItem["description"],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 50.0,
      //   child: Consumer<CartModel>(
      //     builder:(context,cartModel,child){
      //       return RaisedButton(
      //         child: Text(
      //           "ADD TO CART",
      //           style: TextStyle(
      //             color: Colors.white,
      //           ),
      //         ),
      //         color: Theme.of(context).accentColor,
      //         onPressed: (){
      //           if(cartModel.cart.contains(FoodInCart(widget.foodItem))){
      //             Fluttertoast.showToast(msg: "Item Already Present In Cart");
      //           }
      //           else{
      //
      //             cartModel.addToCart(FoodInCart(widget.foodItem));
      //             Fluttertoast.showToast(msg: "Item Added To Cart");
      //           }
      //           setState(() {
      //
      //           });
      //         },
      //       );
      //     },
      //
      //   ),
      // ),
    );
  }
}
