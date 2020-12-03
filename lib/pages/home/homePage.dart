import 'dart:ffi';

import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/pages/addListing.dart';
import 'package:Tyangi/pages/home/components/body.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  List<String> categories = List<String>();
  List<Listing> featuredListings = List<Listing>();

  Future<void> loadCategories() async {
    
     List<String> tempCategories = await getCategories();
     setState(() {
       categories.clear();
       categories.addAll(tempCategories);
     });
  }

  Future<void> loadFeaturedListings() async {
    
     List<Listing> tempListings = await getListings();
     setState(() {
       featuredListings.clear();
       featuredListings.addAll(tempListings);
     });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    loadCategories();
    loadFeaturedListings();
  }

  Future<void> _onRefresh() async{
    await loadCategories();
    await  loadFeaturedListings();
    return;
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var _height= MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: _height/20, horizontal: 10),
          child: Column(
              children: [OutlinedButton(
                child: Text("Sign Out"),
                onPressed: signOut,  
              )]
            ),
        )
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //   floatingActionButton: SizedBox(
      //     height: 50,
      //     child: FloatingActionButton.extended(
      //       onPressed: () {
      //         Navigator.of(context).push(
      //           Platform.isAndroid ?
      //           MaterialPageRoute(builder: (_)=> AddListing())
      //           :
      //           CupertinoPageRoute(builder: (_)=>AddListing())
      //         );
      //       },
      //       icon: Icon(Icons.add),
      //       label:
              
                
      //           Text("New Listing")
              
            
      //     ),
      //   ),
      body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: categories.isEmpty || featuredListings.isEmpty ? 
            Center(child: CircularProgressIndicator()) :
            Body(categories: categories, featuredListings: featuredListings)
        )
      
      );
    // return FutureBuilder<DocumentSnapshot>(
    //         future: FirebaseFirestore.instance.collection('Users').doc(user.uid).get(),
    //         builder: (context, snapshot) {
    //           if(snapshot.connectionState == ConnectionState.done){

    //             Map<String, dynamic> data = snapshot.data.data();
    //             return Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   "${user.email}"
    //                 ),
    //                 Text(
    //                   "${user.uid}"
    //                 ),
    //                 Text(
    //                   "${data['name']}"
    //                 ),
    //                 Text(
    //                   "${data['location']}"
    //                 ),
    //                 FlatButton(
    //                   color: Colors.blue,
    //                   onPressed: () async {
    //                     await FirebaseAuth.instance.signOut();

    //                   },
    //                   child: Text("Sign Out")
    //                   )
    //               ],
    //             );
    //           }
    //           if(snapshot.hasError){
    //             return Text("Somethin went wrong");
    //           }

    //           return CircularProgressIndicator();
    //         }
    //       );
        
  }
}