import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/pages/details/details_screen.dart';
import 'package:Tyangi/widgets/Inputs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class FeaturedCard extends StatefulWidget {
  const FeaturedCard({
    Key key,
    this.width = 160,
    this.aspectRatioImage = 1.35,
    this.aspectRatioCard = 1,
    this.fontSizeMultiple =1,
    @required this.pageTag,
    @required this.slider,
    // @required this.listing,
    this.showMenu = false,
  }) : super(key: key);

  final double width, aspectRatioCard, aspectRatioImage, fontSizeMultiple;
  // final Listing listing;
  final String pageTag, slider;
  static const List<String> menuChoices = ["Mark as Sold", "Renew", "Promote"];
  final bool showMenu;

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  bool enableRenew;
  String slider;
  String listingTitle;
  List<Listing> listings = List<Listing>();
  Listing selectedListing;
  bool isLoading = false;
  Offering _offer;
  Package _package;
  PurchaserInfo _purchaserInfo;
  String productIdentifier;
 

  loadCurrentUserListings() async{
    var snap = await FirebaseFirestore.instance.collection('Listings')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      
      listings.clear();
    });
    snap.docs.forEach((doc) {
      setState(() {
        listings.add(Listing.fromJson(doc.data()));
      });
     });
  }

  promoteListing(Listing listing) async {
    
    var expirationTime  = Timestamp.fromDate(DateTime.now().add(Duration(hours: 72)));
    await FirebaseFirestore.instance.collection(widget.slider).add({
      ...listing.toJson(),
      'expirationTime': expirationTime
    });
  }

  setupPurchases() async {
    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      // print(_purchaserInfo.entitlements);
    } on PlatformException catch (e) {
      print(e);
    }

    Offerings offerings;
    // try {
    //   var products = await Purchases.getProducts(['premium_ad_test'], type: PurchaseType.inapp);
    //   if(products.isNotEmpty){
    //     print("premium ad: $products");
    //   }
    //   offerings = await Purchases.getOfferings();
    //   if (offerings.current != null) {
    //     // Display current offering with offerings.current
    //     Offering offer  = offerings.all['test_offering'];
    //     if(offer!=null){
    //       if (!mounted) return;
    //       setState(() {
    //         _offer = offer;
    //         _package = offer.getPackage('tokens-10');
    //       });
    //     }
    // }
    // } on PlatformException catch (e) {
    //   print(e);
    // }
    if (!mounted) return;
    
    setState(() {
      _purchaserInfo = purchaserInfo;
      // _offerings = offerings;
    });
    // print(_purchaserInfo);
  
  }

  buy(BuildContext context) async {
    var selectedListing = listings.where((listing) => listing.title == listingTitle);
    if(selectedListing.isNotEmpty){

      try {
        PurchaserInfo purchaserInfo = await Purchases.purchaseProduct(productIdentifier, type: PurchaseType.inapp);
        setState(() {
          isLoading = true;
        });
        await promoteListing(selectedListing.first);
        setState(() {
          isLoading = false;
        });
        showDialog(context: context,
          builder: (_) => AlertDialog(
            content: Text("Listing Promoted Successfully"),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(_).pop();
                  Navigator.of(context).pop();
                }, 
                child: Text("Ok")
              )
            ],
          )
        );
        print("Bought tokens successfully");
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          // showSnackbar(e);
          showDialog(context: context,
          builder: (_) => AlertDialog(
            content: Text("Purchase was cancelled"),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(_).pop();
                  Navigator.of(context).pop();
                }, 
                child: Text("Ok")
              )
            ],
          )
        );
          print("Error $e");             
        } else{
           showDialog(context: context,
          builder: (_) => AlertDialog(
            content: Text("an error occurred"),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(_).pop();
                  Navigator.of(context).pop();
                }, 
                child: Text("Ok")
              )
            ],
          )
        );
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadCurrentUserListings();
    setupPurchases();
    productIdentifier = 'premium_ad_test';
    super.initState();
  }

  _bottomSheet(BuildContext context) async{
    await loadCurrentUserListings();
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, newState) {
            return SingleChildScrollView(
              child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
                child: Column(
                  children: [
                    Text("Promote", style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 20),
                    // dropDown(
                    //   // focusNode: focusNodes['contactOption'],
                    //   hint: "Slider", 
                    //   value: slider,
                    //   items: ["Premium", "Services"],
                    //   onChanged: (item) {
                    //       setState(() {
                    //         slider = item;
                    //       });
                          
                        
                    //   },
                    // ),
                    // SizedBox(height: 10),
                    dropDown(
                      // focusNode: focusNodes['contactOption'],
                      hint: "Listing", 
                      value: listingTitle,
                      items: listings.map((listing) => listing.title).toList(),
                      onChanged: (item) {
                          newState(() {
                            listingTitle = item;
                          });
                          
                        
                      },
                    ),
                    // CupertinoTextField(
                    //   // controller: _commentController,
                    //   minLines: 3,
                    //   maxLines: 5,
                    //   maxLength: 200,
                    //   placeholder: "Comment",
                    //   keyboardType: TextInputType.multiline,
                    // ),
                    submitButton(
                        hint: "Promote",
                        isLoading: isLoading,
                        onSubmit: 
                          () async {
                            newState((){
                              isLoading=true;
                            });
                            await buy(context);
                            if(mounted){
                              newState((){
                              isLoading=false;
                            });
                            }
                              print("Promoted");
                            
                            // Navigator.of(context).pop();
                          },
                        context: context
                     )
                  ],
                ),
              ),
            ));
          }
        );
    });
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true, 
    //   builder: (_) {
    //     return SingleChildScrollView(
    //       child: Container(
    //         padding: EdgeInsets.only(
    //                 bottom: MediaQuery.of(context).viewInsets.bottom),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Text("Leave a Feedback", style: Theme.of(context).textTheme.headline4,),
    //             SizedBox(height: 30),
    //             RatingBar.builder(
    //               initialRating: 3,
    //               minRating: 1,
    //               direction: Axis.horizontal,
    //               allowHalfRating: true,
    //               itemCount: 5,
    //               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
    //               itemSize:   30,
    //               itemBuilder: (context, _) => Icon(
    //                 Icons.star,
    //                 color: Colors.amber,
    //               ),
    //               onRatingUpdate: (rating) {
    //                 print(rating);
    //               },
    //             ),
    //             SizedBox(height: 20),
    //             Padding(
    //               padding: EdgeInsets.only(
    //                   bottom: MediaQuery.of(context).viewInsets.bottom),
    //               child: TextField()
    //               //richEntryField("Comment", minLines: 3, maxLines: 5),
    //             ),
    //             SizedBox(height: 30),
    //             submitButton(
    //               hint: "Submit",
    //               onSubmit: (){},
    //               context: context
    //             )
    //             // FlatButton(
    //             //   onPressed: (){},
    //             //   child: Text("Submit"),
    //             //   color: Theme.of(context).primaryColor,
    //             // )
    //           ]
    //         ),
    //       ),
    //     );
    //   }
    // );
  }
  
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    return AspectRatio(
      aspectRatio: widget.aspectRatioCard,
      child: Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12)
    ),
    child: InkWell(
      onTap: () async {
        await loadCurrentUserListings();
        print("tapped");
        if(listings.isEmpty){
          showDialog(context: context,
                      builder: (_) => AlertDialog(
                        content: Text("You don't have any listings"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(_).pop();
                            }, 
                            child: Text("Ok")
                          )
                        ],
                      )
                    );
                    return;
        }
        _bottomSheet(context);
        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailsScreen(listing: widget.listing, pageTag: widget.pageTag,)));
      },
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          // color: Colors.grey.withOpacity(0.5),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider("https://lh3.googleusercontent.com/-V18gxy3x8Wg/X8kSSh5TpcI/AAAAAAAAACI/8Yc6o_t6iQUmnO_ZsAKWdZ_Y-mcm5FnWgCK8BGAsYHg/s0/2020-12-03.png"),
                            fit: BoxFit.contain
                          )
                        ),
                      ),
            ),
            
          ),
          Positioned(
            bottom: 7,
            left: 10,
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SizedBox(height: _height/20,),
                child: Container(
                  child: Text("",
                  // maxLines: 1,
                  // softWrap: true,
                  overflow: TextOverflow.ellipsis, 
                  style: TextStyle(fontSize: (_height/45)*widget.fontSizeMultiple, 
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500
                          ),
                  ),
                ),
                // Row(
                //   children: [
                //     Icon(Icons.location_on_outlined, size: _height/70,),
                //     Text("location", 
                //       style: TextStyle(
                //           fontSize: (_height/70)*widget.fontSizeMultiple
                //         )
                //       )
                //   ],
                // )
            //   ],
            // )
          ),
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: Container(
          //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             color: Colors.grey.withAlpha(180),
          //           ),
          //           child: Text("\$"+widget.listing.price, style: TextStyle(color: Colors.white, fontSize: (_height/50)*widget.fontSizeMultiple),)
          //         ),
          // ),
          // if (widget.showMenu)
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: PopupMenuButton<String>(
          //               onSelected: (value){
          //                 handleSelect(value);
          //               },
          //               itemBuilder: (context){
          //                 return ListingCard.menuChoices.map(
          //                   (choice) {
          //                     // bool enabled = true;
          //                     // if(choice == 'Renew'){
          //                     //   if(Timestamp.now().toDate().difference(widget.listing.createdAt.toDate()).inHours >= 6){
          //                     //     enabled = true;
          //                     //   } else {
          //                     //     enabled = false;
          //                     //   }
          //                     // }
          //                     return PopupMenuItem<String>(
          //                       value: choice,
          //                       child: Text(choice),
          //                       enabled: choice == 'Renew' ? enableRenew : true,
          //                     );
          //                   }
          //                 ).toList();
          //               }
          //             ),
          // ),

        ]
      ),
    ),
        ),
      );
  }
}