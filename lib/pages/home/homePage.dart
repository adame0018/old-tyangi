import 'dart:async';
import 'dart:ffi';

import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/pages/addListing.dart';
import 'package:Tyangi/pages/home/components/body.dart';
import 'package:Tyangi/pages/listings/searchResults.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  AppUser currentUser;
  List<String> categories = List<String>();
  List<Listing> featuredListings = List<Listing>();
  double radius = 50*1.6;
  bool isSlider = false;
  double label = 50*1.6;
  TextEditingController searchController;
  FocusNode searchFocus = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    loadCategories();
    loadFeaturedListings();
    loadCurrentUser();
    getRadius();
    searchController = TextEditingController();
  }

  loadCurrentUser() async {
    var temp = await
    getUserFromId(FirebaseAuth.instance.currentUser.uid);
    setState(() {
      currentUser = temp;
    });
  }

  getRadius() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      radius= prefs.getDouble('radius') ?? 50*1.6;
      
    });
    // double rad = prefs.getDouble('radius') ?? 50*1.6;
    // return rad;
    // print('Pressed $counter times.');
    // await prefs.setInt('counter', counter);
  }

  setRadius(double rad) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('radius', rad);
    setState(() {
      radius = rad;
      // isSlider = !isSlider;
    });
    // Timer(
    //   Duration(seconds: 1), 
    //   setState((){

    //   })
    //   );
  }

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
      appBar: AppBar(
        // heroTag: 'homePage',
        backgroundColor: Colors.white,
        elevation: 2.0,        
        automaticallyImplyLeading: false,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
            onTap: (){
              setState(() {
                isSlider = !isSlider;
              });
              // showDialog(
              //   context: context,
              //   builder: (_){
              //     return AlertDialog(
              //       insetPadding: EdgeInsets.zero,
              //       contentPadding: EdgeInsets.zero,
              //       content: Slider(
              //         label: "Radius",
              //         min: 10*1.6,
              //         max: 50*1.6,
              //         value: radius, 
              //         onChanged: (rad){
              //           setRadius(rad);
              //         }
              //     ),
              //     );
              //   }
              // );
            },
            child: 
              AnimatedCrossFade(
                firstChild: Text("Close", style: TextStyle(color: Colors.blue),),
                secondChild: Icon(Icons.map_outlined, color: Colors.blue,),
                crossFadeState: isSlider ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 300),
              )
            // isSlider ? Text("Close", style: TextStyle(color: Colors.blue),) :
            // Icon(Icons.map_outlined, color: Colors.blue,)
            ),
            // Text("Radius", style: TextStyle(color: Colors.white),),),
          ],
        ),
        
        title: AnimatedCrossFade(
            firstChild: Slider(
            label: "${radius/1.6} mi",
            // activeColor: Colors.white,
            divisions: 4,
            min: 10*1.6,
            max: 50*1.6,
            value: radius,
            onChanged: (rad){
              setRadius(rad);
            }
          ), 
            secondChild: CupertinoTextField(
              focusNode: searchFocus,
              controller: searchController,
              onSubmitted: (value){
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => SearchResults(searchParam: searchController.text))
                );
              },
              padding: EdgeInsets.all(5),
              placeholder: "Search", 
              prefix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(CupertinoIcons.search, color: Colors.black54,),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue)
              ),
              ),  
            crossFadeState: isSlider ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
            duration: Duration(milliseconds: 300),
          ),
        // isSlider ? 
        //   Slider(
        //     label: "$radius mi",
        //     activeColor: Colors.white,
        //     divisions: 5,
        //     min: 10*1.6,
        //     max: 50*1.6,
        //     value: radius,
        //     onChanged: (rad){
        //       setRadius(rad);
        //     }
        //   )
        //   : CupertinoTextField(placeholder: "Search",),
        // trailing: Icon(CupertinoIcons.search, size: 18, color: Colors.white,),
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: _height/20, horizontal: 10),
          child: Column(
              children: [
                SizedBox(height: _height/40),
                 AspectRatio(
              aspectRatio: 3,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      // "https://loremflickr.com/640/360"
                      currentUser == null ? "https://firebasestorage.googleapis.com/v0/b/tyangi-18c2e.appspot.com/o/PngItem_4212617.png?alt=media&token=f350715b-249e-4316-94a1-e19083c38dc4" :
                      currentUser.profilePic ??"https://firebasestorage.googleapis.com/v0/b/tyangi-18c2e.appspot.com/o/PngItem_4212617.png?alt=media&token=f350715b-249e-4316-94a1-e19083c38dc4"
                    ),
                    fit: BoxFit.contain
                  )
                ),
                )
                
              ),
              SizedBox(height: _height/40),
              Text(
                currentUser==null ? "" : currentUser.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: _height/40),
               InkWell(
            onTap: (){
              
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  top:BorderSide(width: 1, color: Colors.grey),
                  bottom: BorderSide(width: 1, color: Colors.grey),
                )
              ),
              child: Text(
                 "Repost Tokens: ${currentUser==null ? "" : currentUser.repostTokens??0}",
                style: TextStyle(
                  fontSize: 18,
                ),  
              )
            ),
          ),
              SizedBox(height: _height/20),
                OutlinedButton(
                child: Text("Sign Out"),
                onPressed: signOut,  
              ),

             
              ]
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
      body: GestureDetector(
        onTap: searchFocus.unfocus,
              child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: categories.isEmpty || featuredListings.isEmpty ? 
              Center(child: CircularProgressIndicator()) :
              Body(categories: categories, featuredListings: featuredListings, radius: radius)
          ),
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