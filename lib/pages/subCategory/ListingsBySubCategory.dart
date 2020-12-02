import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/pages/home/components/featuredListings.dart';
import 'package:Tyangi/widgets/ListingCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListingsBySubCategory extends StatefulWidget {
  final String subCategory;
  ListingsBySubCategory({
    @required this.subCategory
  });
  @override
  _ListingsBySubCategoryState createState() => _ListingsBySubCategoryState();
}

class _ListingsBySubCategoryState extends State<ListingsBySubCategory> {
  List dataList = new List<Listing>();
  bool isLoading = false;
  int pageCount = 1;
  ScrollController scrollController;
  var _lastListing;

  Future<void> addItemIntoLisT() async {
    // for (int i = (pageCount * 10) - 10; i < pageCount * 10; i++) {
    //   dataList.add(i);
    //   isLoading = false;
    // }
    // var temp = await getListings();
    // setState(() {
    //   dataList.addAll(temp);
    // });
    QuerySnapshot snap;
    if(_lastListing == null){
      snap = await FirebaseFirestore.instance.collection('Listings').where('subCategory', isEqualTo: widget.subCategory).orderBy('createdAt').limit(24).get();
      
      // setState(() {
      //     snap.docs.forEach((doc) async {
      //       dataList.add(new Listing.fromJson(doc.data()));
      //     });
      //     // _lastListing = snap.docs[snap.size - 1];
      //   // dataList.addAll(temp);
      // });
    }
    else {
      snap = await FirebaseFirestore.instance.collection('Listings').where('subCategory', isEqualTo: widget.subCategory).orderBy('createdAt').startAfterDocument(_lastListing).limit(16).get();
      // setState(() {
          
      //     // _lastListing = snap.docs[snap.size - 1];
      //   // dataList.addAll(temp);
      // });
    }

    if (snap != null && snap.size > 0) {
      _lastListing = snap.docs[snap.size - 1];
      if (mounted) {
        setState(() {
         snap.docs.forEach((doc) async {
            dataList.add(new Listing.fromJson(doc.data()));
          });
          isLoading = false;
        });
      }
    } else {
      setState(() => isLoading = false);
      // scaffoldKey.currentState?.showSnackBar(
      //   SnackBar(
      //     content: Text('No more posts!'),
      //   ),
      // );
    }
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
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(widget.subCategory),
      ),
      body: dataList.isEmpty ? Center(
        child: Text("No Listings Found"),
      ) : 
        GridView.count(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 4,
                    mainAxisSpacing: 10.0,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    childAspectRatio: 0.7,
                    // physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      ...dataList.map((value) {
                        return ListingCard(listing: value, aspectRatioImage: 0.97,fontSizeMultiple: 0.8, pageTag: "subCategory",);
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
                  )
    );
  }
}