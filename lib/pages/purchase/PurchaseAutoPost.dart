import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseAutoPost extends StatefulWidget {
  @override
  _PurchaseAutoPostState createState() => _PurchaseAutoPostState();
}

class _PurchaseAutoPostState extends State<PurchaseAutoPost> {
  AppUser user;
  Offering _offer;
  Package _package;
  PurchaserInfo _purchaserInfo;
  String bought = 'not bought';
  GlobalKey<ScaffoldState> _scaffoldKey;

  // setupPurchases() async {
  //   PurchaserInfo purchaserInfo;
  //   try {
  //     purchaserInfo = await Purchases.getPurchaserInfo();
  //     // print(_purchaserInfo.entitlements);
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   Offerings offerings;
  //   try {
  //     offerings = await Purchases.getOfferings();
  //     if (offerings.current != null) {
  //       // Display current offering with offerings.current
  //       Offering offer  = offerings.all['test_offering'];
  //       if(offer!=null){
  //         if (!mounted) return;
  //         setState(() {
  //           _offer = offer;
  //           _package = offer.getPackage('tokens-10');
  //         });
  //       }
  //   }
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
    
  //   setState(() {
  //     _purchaserInfo = purchaserInfo;
  //     // _offerings = offerings;
  //   });
  //   // print(_purchaserInfo);
  
  // }

  buy({int quantity, String productIdentifier}) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchaseProduct(productIdentifier, type: PurchaseType.inapp);
      await FirebaseFirestore.instance.collection('Users').doc('${FirebaseAuth.instance.currentUser.uid}').update({
        'repostTokens': user.repostTokens + quantity
      });
      Purchases.syncPurchases();
      await loadUser();
      showSnackBar("Purchase successful!");
      print("Bought tokens successfully");
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        showSnackBar("Purchase was cancelled");
        print("Error $e");             
      } else{
        showSnackBar("An error occured! Purchase was unsuccessful");
      }
    }
  }
  loadUser() async{
    var temp = await getUserFromId('${FirebaseAuth.instance.currentUser.uid}');
    if (!mounted) return;
    setState(() {
      user = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    loadUser();
    // setupPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Purchase Auto Repost Tokens",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getRepostTokenPackages(),
        builder: (context, snapshot) {
          if(snapshot.hasData){

            return Center(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  var quantity = snapshot.data[index]['quantity'];
                  var productIdentifier = snapshot.data[index]['productIdentifier'];
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
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.ticket,
                              color: Theme.of(context).primaryColor
                            ),
                            SizedBox(width: 10,),
                            Text("$quantity Repost Tokens", style: Theme.of(context).textTheme.subtitle1,),
                          ],
                        ),
                        FlatButton(
                          onPressed: () async {
                            await buy(quantity: quantity, productIdentifier: productIdentifier);
                          }, 
                          child: Text("Buy"),
                          textColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                              style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.circular(30.0))
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          } else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
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