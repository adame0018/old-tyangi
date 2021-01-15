import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:Tyangi/widgets/ListingCard.dart';
import 'package:Tyangi/widgets/sliders/featuredCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utitlities/sizeConfig.dart';
import '../../models/Listing.dart';

class PremiumSlider extends StatefulWidget {
  PremiumSlider({
    // @required this.listings,
    @required this.title,
    @required this.orientation
  });
  // final List<Listing> listings;
  final String title;
  final Orientation orientation;

  @override
  _PremiumSliderState createState() => _PremiumSliderState();
}

class _PremiumSliderState extends State<PremiumSlider> {
  List<dynamic> listings = List<dynamic>();
  AppUser user;
  Stream stream;

  loadListings() async {
    var temp = await getUserFromId(FirebaseAuth.instance.currentUser.uid);
    setState(() {
      user = temp;
    });
    var collectionRef = FirebaseFirestore.instance.collection('PremiumSlider');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double radius = prefs.getDouble('radius') ?? 50*1.6;
    GeoFirePoint center = Geoflutterfire().point(latitude: user.position['geopoint'].latitude, longitude: user.position['geopoint'].longitude);
    print("bruh:${center.latitude}");
    setState(() {
      stream = Geoflutterfire().collection(collectionRef: collectionRef).within(center: center, radius: radius, field: 'position',);
    });
  }

  List<Widget> getFeaturedCards(int length){
    List<Widget> cards = List<Widget>();
    for(int i=0; i<9-length; i++){
                  cards.add(FeaturedCard(pageTag: "PremiumSlider$i", slider: "PremiumSlider", productIdentifier: "premium_slider",));
                }
    return cards;
  }
  @override
  void initState() {
    // TODO: implement initState
    loadListings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      var _height = MediaQuery.of(context).size.height;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
              child: Text(
                widget.title, 
                style: TextStyle(
                  fontSize: widget.orientation == Orientation.landscape ?_height/20 : _height/40, 
                  fontWeight: FontWeight.w700 ),),
            ),
            // SizedBox(height: getProportionateScreenWidth(20)),
            AspectRatio(
              aspectRatio: widget.orientation == Orientation.landscape ? 5 : 21.5/9,
                      child: Container(
                // height: _height / 3.5,
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: stream,
                  builder: (context, snapshot) {
                    print("premium slider snapshot");
                    print(snapshot.hasData);
                    if(snapshot.hasData){
                      var time  = Timestamp.now();
                      snapshot.data.removeWhere((listing) 
                        {
                          Timestamp expirationTime = listing['expirationTime'];
                          return expirationTime.compareTo(time) < 0;
                      });
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...snapshot.data.map((listing) => 
                            ListingCard(
                              pageTag: "PremiumSlider", 
                              listing: Listing.fromJson(listing.data()),
                              showExpiration: true,  
                            )).toList(),
                          ...getFeaturedCards(snapshot.data.length)

                        ]
                      );
                    } if (snapshot.connectionState==ConnectionState.done && snapshot.data == null){

                      return ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...getFeaturedCards(0)
                          ]
                        );
                    } 
                      return ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...getFeaturedCards(0)
                          ]
                        );;
                    

                  }
                )
                
                // ListView.builder(
                //   itemCount: 9,
                //   scrollDirection: Axis.horizontal,
                //   itemBuilder: (context, index){
                //     return ListingCard(listing: listings[index], pageTag: "Home",);
                //   },
                  // children: [
                  //       ProductCard(),
                  //   //SizedBox(width: getProportionateScreenWidth(20)),
                  //     //   ProductCard(),
                  //     // //  SizedBox(width: getProportionateScreenWidth(20)),
                  //     //   ProductCard(),
                  //     //   ProductCard(),
                  //     //   ProductCard()
                  //        // here by default width and height is 0
                      
                    
                  // ],
                ),
              ),
            
          ],
        );
      }
}

