import 'package:Tyangi/widgets/ListingCard.dart';
import 'package:Tyangi/widgets/sliders/featuredCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utitlities/sizeConfig.dart';
import '../../models/Listing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../pages/details/details_screen.dart';

class VehiclesSlider extends StatefulWidget {
  VehiclesSlider({
    // @required this.listings,
    @required this.title,
    @required this.orientation
  });
  // final List<Listing> listings;
  final String title;
  final Orientation orientation;

  @override
  _VehiclesSliderState createState() => _VehiclesSliderState();
}

class _VehiclesSliderState extends State<VehiclesSlider> {
  List<dynamic> listings = List<dynamic>();

  loadListings() async {
    var snap = await FirebaseFirestore.instance.collection('VehiclesSlider').get();
    snap.docs.forEach((doc) {
      setState(() {
        listings.add(Listing.fromJson(doc.data()));
        print("adding");
      }); 
     });
  }

  List<Widget> getFeaturedCards(){
    List<Widget> cards = List<Widget>();
    for(int i=0; i<9-listings.length; i++){
                  cards.add(FeaturedCard(pageTag: "VehiclesSlider$i", slider: "VehiclesSlider",));
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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...listings.map((listing) => ListingCard(pageTag: "VehiclesSlider", listing: listing)).toList(),
                ...getFeaturedCards()

              ]
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
