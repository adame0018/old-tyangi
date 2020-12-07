import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/pages/home/components/categories.dart';
import 'package:Tyangi/pages/home/components/featuredListings.dart';
import 'package:Tyangi/pages/subCategory/subCategories.dart';
import 'package:Tyangi/widgets/InfiniteGridView.dart';
import 'package:Tyangi/widgets/sliders/premiumSlider.dart';
import 'package:Tyangi/widgets/sliders/servicesSlider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utitlities/firebase.dart';
import 'package:flutter/material.dart';
import '../../../models/Listing.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Body extends StatefulWidget {
  Body({
    @required this.categories,
    @required this.featuredListings,
    @required this.radius
  });
  final List<String> categories;
  final List<Listing> featuredListings;
  final double radius;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ScrollController scrollController;

  List dataList = new List<Listing>();

  bool isLoading = false;
  var _lastListing;
  AppUser user;
  Stream stream;


  Future<void> addItemIntoLisT() async {
    // for (int i = (pageCount * 10) - 10; i < pageCount * 10; i++) {
    //   dataList.add(i);
    //   isLoading = false;
    // }
    
    // var temp = await getListings();
    // setState(() {
    //   dataList.addAll(temp);
    // });
    // QuerySnapshot snap;
    // if(_lastListing == null){
    //   snap = await FirebaseFirestore.instance.collection('Listings').limit(10).get();
      
    //   // setState(() {
    //   //     snap.docs.forEach((doc) async {
    //   //       dataList.add(new Listing.fromJson(doc.data()));
    //   //     });
    //   //     // _lastListing = snap.docs[snap.size - 1];
    //   //   // dataList.addAll(temp);
    //   // });
    // }
    // else {
    //   snap = await FirebaseFirestore.instance.collection('Listings').startAfterDocument(_lastListing).limit(8).get();
    //   // setState(() {
          
    //   //     // _lastListing = snap.docs[snap.size - 1];
    //   //   // dataList.addAll(temp);
    //   // });
    // }

    // if (snap != null && snap.size > 0) {
    //   _lastListing = snap.docs[snap.size - 1];
    //   if (mounted) {
    //     setState(() {
    //      snap.docs.forEach((doc) async {
    //         dataList.add(new Listing.fromJson(doc.data()));
    //       });
    //       isLoading = false;
    //     });
    //   }
    // } else {
    //   setState(() => isLoading = false);
    //   // scaffoldKey.currentState?.showSnackBar(
    //   //   SnackBar(
    //   //     content: Text('No more posts!'),
    //   //   ),
    //   // );
    // }
  }

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

  loadUser()async{
    var temp = await getUserFromId(FirebaseAuth.instance.currentUser.uid);
    setState(() {
      user = temp;
    });
    print("USer");
   print(user.position);
   print(user.position['geopoint'].latitude);
       CollectionReference collectionRef = FirebaseFirestore.instance.collection('Listings');

   GeoFirePoint center = Geoflutterfire().point(latitude: user.position['geopoint'].latitude, longitude: user.position['geopoint'].longitude);
   setState(() {
     
    stream = Geoflutterfire().collection(collectionRef: collectionRef).within(center: center, radius: widget.radius, field: 'position',);
   });
  }

  @override
  void initState() {
    super.initState();
   loadUser();
   

    // CollectionReference collectionRef = FirebaseFirestore.instance.collection('Listings');
    // print(user.position.geopoint.latitude);
    // GeoFirePoint center = Geoflutterfire().point(latitude: user.position.geopoint.latitude, longitude: user.position.geopoint.longitude);
    // stream = Geoflutterfire().collection(collectionRef: collectionRef).within(center: center, radius: 10000, field: 'position',);
    ////LOADING FIRST  DATA
    // addItemIntoLisT();
    // print(user.position);
    // var point = Geoflutterfire().point(latitude: null, longitude: null)
    scrollController = new ScrollController(initialScrollOffset: 5.0);
    scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Categories(categories: widget.categories),
            PremiumSlider(title: "Premium"),

            SizedBox(
              height:25,
            ),
            ServicesSlider(title: "Services"),
            SizedBox(
              height:25,
            ),
            FeaturedListings(listings: widget.featuredListings, title: "Featured"),
            // FeaturedListings(listings: widget.featuredListings, title: "Popular",),
            // SizedBox(
            //   height:25,
            // ),
            // FeaturedListings(listings: widget.featuredListings, title: "Premium"),
            // SizedBox(
            //   height:25,
            // ),
            // // InfiniteGridView(),
            SizedBox(
              height:25,
            ),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: stream,
              builder: (context, snapshot) {
                print("snapshit");
                print(snapshot.hasData);
                if(snapshot.hasData){

                return GridView.count(
                        // controller: scrollController,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 4,
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        childAspectRatio: 0.7,
                        // physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          ...snapshot.data.map(
                            (e) => ProductCard(pageTag: "gridview", listing: Listing.fromJson(e.data()), aspectRatioImage: 0.97,fontSizeMultiple: 0.8)
                          ).toList()
                        //   ...dataList.map((value) {
                        //     return ProductCard(listing: value, aspectRatioImage: 0.97,fontSizeMultiple: 0.8,);

                        // }).toList(),
                        
                        ]
                      );
                }
                else {
                  return CircularProgressIndicator();
                }
              }
            )
          ],
        ),
      ),
    );
  }
}




// class GridCards extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//                     // controller: scrollController,
//                     scrollDirection: Axis.vertical,
//                     crossAxisCount: 4,
//                     mainAxisSpacing: 10.0,
//                     shrinkWrap: true,
//                     physics: BouncingScrollPhysics(),
//                     childAspectRatio: 0.7,
//                     // physics: const AlwaysScrollableScrollPhysics(),
//                     children: [
//                       ...dataList.map((value) {
//                         return ProductCard(listing: value, aspectRatioImage: 0.97,fontSizeMultiple: 0.8,);

//                     }).toList(),
                    
//                     ]
//                   );
//   }
// }