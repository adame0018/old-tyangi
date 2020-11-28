import 'package:Tyangi/pages/home/components/categories.dart';
import 'package:Tyangi/pages/home/components/featuredListings.dart';
import 'package:Tyangi/widgets/InfiniteGridView.dart';
import '../../../utitlities/firebase.dart';
import 'package:flutter/material.dart';
import '../../../models/Listing.dart';

class Body extends StatefulWidget {
  Body({
    @required this.categories,
    @required this.featuredListings
  });
  final List<String> categories;
  final List<Listing> featuredListings;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ScrollController scrollController;

  List dataList = new List<Listing>();

  bool isLoading = false;
  var _lastListing;

  Future<void> addItemIntoLisT() async {
    // for (int i = (pageCount * 10) - 10; i < pageCount * 10; i++) {
    //   dataList.add(i);
    //   isLoading = false;
    // }
    var temp = await getListings();
    setState(() {
      dataList.addAll(temp);
    });
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

          addItemIntoLisT();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    ////LOADING FIRST  DATA
    addItemIntoLisT();

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
            
            FeaturedListings(listings: widget.featuredListings, title: "Featured"),
            SizedBox(
              height:25,
            ),
            // FeaturedListings(listings: widget.featuredListings, title: "Popular",),
            // SizedBox(
            //   height:25,
            // ),
            // FeaturedListings(listings: widget.featuredListings, title: "Premium"),
            // SizedBox(
            //   height:25,
            // ),
            // // InfiniteGridView(),
            // GridView.count(
            //         // controller: scrollController,
            //         scrollDirection: Axis.vertical,
            //         crossAxisCount: 4,
            //         mainAxisSpacing: 10.0,
            //         shrinkWrap: true,
            //         physics: BouncingScrollPhysics(),
            //         childAspectRatio: 0.7,
            //         // physics: const AlwaysScrollableScrollPhysics(),
            //         children: [
            //           ...dataList.map((value) {
            //             return ProductCard(listing: value, aspectRatioImage: 0.97,fontSizeMultiple: 0.8,);

            //         }).toList(),
                    
            //         ]
            //       )
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