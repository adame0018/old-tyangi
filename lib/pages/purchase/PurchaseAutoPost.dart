import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  setupPurchases() async {
    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      // print(_purchaserInfo.entitlements);
    } on PlatformException catch (e) {
      print(e);
    }

    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        // Display current offering with offerings.current
        Offering offer  = offerings.all['test_offering'];
        if(offer!=null){
          if (!mounted) return;
          setState(() {
            _offer = offer;
            _package = offer.getPackage('tokens-10');
          });
        }
    }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    
    setState(() {
      _purchaserInfo = purchaserInfo;
      // _offerings = offerings;
    });
    // print(_purchaserInfo);
  
  }

  buy() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(_package);
      await FirebaseFirestore.instance.collection('Users').doc('${FirebaseAuth.instance.currentUser.uid}').update({
        'repostTokens': user.repostTokens + 1
      });
      loadUser();
      print("Bought tokens successfully");
      // var isPro = purchaserInfo.entitlements.all["auto_post_test"].isActive;
      // print("PRooo: $isPro");
      // if (isPro) {
      //   // Unlock that great "pro" content
      //   setState(() {
      //     bought = 'You have bought tokens';
      //   });
      // }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        // showSnackbar(e);
        print("Error $e");             
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
    loadUser();
    setupPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Purchase Auto Post Tokens",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: Text('get loc'),
              onPressed: buy,
            ),
            SizedBox(height: 10,),
            Text(bought),
            // _purchaserInfo.entitlements.all["auto_post_test"].isActive ? Text("isPro"): Text("NotPro")
          ],
        ),
      ),
    );
  }
}