import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_flutter/transaction.dart';

class MyPurchases extends StatefulWidget {
  @override
  _MyPurchasesState createState() => _MyPurchasesState();
}

class _MyPurchasesState extends State<MyPurchases> {
  AppUser user;
   PurchaserInfo _purchaserInfo;
  List<Transaction>_transactions;
  List<Product> _products;
  List<Map<String, dynamic>> _purchases;
  GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isLoading=false;

  loadPurchases() async{
    setState(() {
      _isLoading = true;
    });
    var purchaserInfo = await Purchases.getPurchaserInfo();
    setState(() {
      _purchaserInfo = purchaserInfo;
      _transactions = purchaserInfo.nonSubscriptionTransactions;
    });
    List<String> productIds = [];
    _transactions.forEach((transaction) {
      productIds.add(transaction.productId);
     });
    List<Product> products = await Purchases.getProducts(productIds, type: PurchaseType.inapp);
    List<Map<String,dynamic>> purchases = [];
    _transactions.forEach((transaction) {
      var product = products.singleWhere((element) => element.identifier == transaction.productId);
      purchases.add({
        'title': product.title.substring(0, product.title.indexOf("(TYANGI)")),
        'price': "${product.priceString}",
        'date': DateTime.tryParse(transaction.purchaseDate)
      });
     });
    setState(() {
      _purchases = purchases;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    loadPurchases();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "My Purchases",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
      ),
      body:Center(
            child: _isLoading ? CircularProgressIndicator() :
            _purchases.isEmpty ? Text("No Purchases to show") :
              ListView.builder(
                itemCount: _purchases.length,
                itemBuilder: (context, index){
                  var title = _purchases[index]['title'];
                  var price = _purchases[index]['price'];
                  DateTime date = _purchases[index]['date'];
                  return Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                            )
                          ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$title", style: Theme.of(context).textTheme.subtitle2,),
                                SizedBox(height: 10),
                                Text("${date.toString().substring(0,10)}", style: Theme.of(context).textTheme.subtitle1,)
                              ],
                            ),
                            Text("$price", style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600
                            ),)
                          ],
                        ),
                      );
                },
              ),
            )
          
        
    );
  }

  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'UNDO', onPressed: _scaffoldKey.currentState.hideCurrentSnackBar),
    );
    _scaffoldKey.currentState.showSnackBar(snackBarContent);
  }
}