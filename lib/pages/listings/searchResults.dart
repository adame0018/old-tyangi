import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/pages/home/components/featuredListings.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:Tyangi/widgets/ListingCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResults extends StatefulWidget {
  final String searchParam;
  Key key;
  SearchResults({this.key, @required this.searchParam}):super(key: key);
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List dataList = new List<Listing>();
  bool isLoading = false;
  int pageCount = 1;
  ScrollController scrollController;
  var _lastListing;
  AppUser user;
  Stream stream;

  @override
  void initState() {
    super.initState();

    ////LOADING FIRST  DATA
    // addItemIntoLisT();
    loadUser();

    scrollController = new ScrollController(initialScrollOffset: 5.0);
    scrollController.addListener(_scrollListener);
  }

  loadUser()async{
    var temp = await getUserFromId(FirebaseAuth.instance.currentUser.uid);
    setState(() {
      user = temp;
    });
       var collectionRef = FirebaseFirestore.instance.collection('Listings');
       SharedPreferences prefs = await SharedPreferences.getInstance();
      double radius = prefs.getDouble('radius') ?? 50*1.6;
      GeoFirePoint center = Geoflutterfire().point(latitude: user.position['geopoint'].latitude, longitude: user.position['geopoint'].longitude);
      setState(() {
        
        stream = Geoflutterfire().collection(collectionRef: collectionRef).within(center: center, radius: radius, field: 'position',);
      });
  }

  // Future<void> addItemIntoLisT() async {
  //   // for (int i = (pageCount * 10) - 10; i < pageCount * 10; i++) {
  //   //   dataList.add(i);
  //   //   isLoading = false;
  //   // }
  //   // var temp = await getListings();
  //   // setState(() {
  //   //   dataList.addAll(temp);
  //   // });
  //   QuerySnapshot snap;
  //   if(_lastListing == null){
  //     snap = await FirebaseFirestore.instance.collection('Listings').where('subCategory', isEqualTo: widget.subCategory).orderBy('createdAt').limit(24).get();
      
  //     // setState(() {
  //     //     snap.docs.forEach((doc) async {
  //     //       dataList.add(new Listing.fromJson(doc.data()));
  //     //     });
  //     //     // _lastListing = snap.docs[snap.size - 1];
  //     //   // dataList.addAll(temp);
  //     // });
  //   }
  //   else {
  //     snap = await FirebaseFirestore.instance.collection('Listings').where('subCategory', isEqualTo: widget.subCategory).orderBy('createdAt').startAfterDocument(_lastListing).limit(16).get();
  //     // setState(() {
          
  //     //     // _lastListing = snap.docs[snap.size - 1];
  //     //   // dataList.addAll(temp);
  //     // });
  //   }

  //   if (snap != null && snap.size > 0) {
  //     _lastListing = snap.docs[snap.size - 1];
  //     if (mounted) {
  //       setState(() {
  //        snap.docs.forEach((doc) async {
  //           dataList.add(new Listing.fromJson(doc.data()));
  //         });
  //         isLoading = false;
  //       });
  //     }
  //   } else {
  //     setState(() => isLoading = false);
  //     // scaffoldKey.currentState?.showSnackBar(
  //     //   SnackBar(
  //     //     content: Text('No more posts!'),
  //     //   ),
  //     // );
  //   }
  // }

  

  _scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if (isLoading) {
          print("RUNNING LOAD MORE");

          // pageCount = pageCount + 1;

          // addItemIntoLisT();
        }
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Search Results for \"${widget.searchParam}\"",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: 
        StreamBuilder<List<DocumentSnapshot>>(
          stream: stream,
          builder: (context, snapshot) {

            if (snapshot.connectionState==ConnectionState.done && snapshot.data == null){
              return Center(child: Text("No Listings Found"));
             
            } 


            if(snapshot.hasData){

              var results = snapshot.data.where(
                (document) {
                  String title = document.data()['title'];
                  String description = document.data()['description'];
                  return title.contains(widget.searchParam) || description.contains(widget.searchParam);
                });

              if(results.isNotEmpty){

              return GridView.count(
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 4,
                          mainAxisSpacing: 10.0,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          childAspectRatio: 0.7,
                          // physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            ...results.map((value) {
                              return ListingCard(
                                listing: Listing.fromJson(value.data()), 
                                aspectRatioImage: 0.97,
                                fontSizeMultiple: 0.8, 
                                pageTag: "subCategory",
                              );
                            // Container(
                            //       alignment: Alignment.center,
                            //       height: MediaQuery.of(context).size.height * 0.2,
                            //       margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            //       decoration: BoxDecoration(
                            //         border: Border.all(color: Colors.black),
                            //       ),
                            //       child: Text("Item ${value}"),
                            //     );


                          }).toList(),
                          
                          ]
                        );
              }else {
                return Center(child: Text("No Results found for \"${widget.searchParam}\""));
              }
            } 
            
            
            return Center(child: CircularProgressIndicator());
            
            // if(snapshot.connectionState == ConnectionState.waiting)
            // {
            //   print("subcategory");
            //   print(snapshot.hasData);
            //   return Center(child: CircularProgressIndicator());
            // }
          }
        )
    );
  }
}