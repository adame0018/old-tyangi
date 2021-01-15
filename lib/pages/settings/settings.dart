import 'package:Tyangi/pages/purchase/PurchaseAutoPost.dart';
import 'package:Tyangi/pages/settings/EditProfile.dart';
import 'package:Tyangi/pages/settings/myPurchases.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_flutter/transaction.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => EditProfile()
                  )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide(width: 1),
                    bottom: BorderSide(width: 1, color: Colors.grey),
                  )
                ),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 20,
                  ),  
                )
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => PurchaseAutoPost()
                  )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide(width: 1),
                    bottom: BorderSide(width: 1, color: Colors.grey),
                  )
                ),
                child: Text(
                  "Buy Repost Tokens",
                  style: TextStyle(
                    fontSize: 20,
                  ),  
                )
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => MyPurchases()
                  )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide(width: 1),
                    bottom: BorderSide(width: 1, color: Colors.grey),
                  )
                ),
                child: Text(
                  "My Purchases",
                  style: TextStyle(
                    fontSize: 20,
                  ),  
                )
              ),
            ),
            InkWell(
              onTap: () async{
                await signOut();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide(width: 1),
                    bottom: BorderSide(width: 1, color: Colors.grey),
                  )
                ),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    fontSize: 20,
                  ),  
                )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  //top: BorderSide(width: 1),
                  bottom: BorderSide(width: 1, color: Colors.grey),
                )
              ),
              child: Text(
                "About",
                style: TextStyle(
                  fontSize: 20,
                ),  
              )
            ),
          ]
        ),
      ),
      
    );
  }
}