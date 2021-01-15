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
    @required this.productIdentifier,
    // @required this.listing,
    this.showMenu = false,
  }) : super(key: key);

  final double width, aspectRatioCard, aspectRatioImage, fontSizeMultiple;
  // final Listing listing;
  final String pageTag, slider, productIdentifier;
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
  String category;
 

  loadCurrentUserListings() async{
    var snap;
    if(widget.slider!="PremiumSlider"){
      snap = await FirebaseFirestore.instance.collection('Listings')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).where('category', isEqualTo: widget.slider.substring(0, widget.slider.indexOf('Slider'))).get();
    } else{
      snap = await FirebaseFirestore.instance.collection('Listings')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    }
    if(!mounted) return;
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
        PurchaserInfo purchaserInfo = await Purchases.purchaseProduct(widget.productIdentifier, type: PurchaseType.inapp);
        if(!mounted) return;
        setState(() {
          isLoading = true;
        });
        await promoteListing(selectedListing.first);
        if(!mounted) return;
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
    if(widget.slider!="PremiumSlider"){
      category = widget.slider.substring(0, widget.slider.indexOf('Slider'));
    } else{
      category = '';
    }
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

                    dropDown(
                      hint: "Listing", 
                      value: listingTitle,
                      items: listings.map((listing) => listing.title).toList(),
                      onChanged: (item) {
                          newState(() {
                            listingTitle = item;
                          });
                          
                        
                      },
                    ),

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
                content: Text("You don't have any $category listings"),
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
          ),

        ]
      ),
    ),
        ),
      );
  }
}