import 'package:Tyangi/widgets/ListingCard.dart';
import 'package:Tyangi/widgets/sliders/featuredCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utitlities/sizeConfig.dart';
import '../../models/Listing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../pages/details/details_screen.dart';

class ServicesSlider extends StatefulWidget {
  ServicesSlider({
    // @required this.listings,
    @required this.title
  });
  // final List<Listing> listings;
  final String title;

  @override
  _ServicesSliderState createState() => _ServicesSliderState();
}

class _ServicesSliderState extends State<ServicesSlider> {
  List<Listing> listings = List<Listing>();

  loadListings() async {
    var snap = await FirebaseFirestore.instance.collection('ServicesSlider').get();
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
                  cards.add(FeaturedCard(pageTag: "ServicesSlider$i",));
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
    return StreamBuilder<dynamic>(
      stream: FirebaseFirestore.instance.collection('ServicesSlider').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
              child: Text(widget.title, style: TextStyle(fontSize: _height/40, fontWeight: FontWeight.w700 ),),
            ),
            // SizedBox(height: getProportionateScreenWidth(20)),
            AspectRatio(
              aspectRatio: 21.5/9,
                      child: Container(
                // height: _height / 3.5,
                child:  ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...listings.map((listing) => ListingCard(pageTag: "ServicesSlider", listing: listing)).toList(),
                    ...getFeaturedCards()

                  ]
                )
                
                // ListView.builder(
                //   itemCount: listings.length,
                //   scrollDirection: Axis.horizontal,
                //   itemBuilder: (context, index){
                //     return ListingCard(listing: listings[index], pageTag: "Home",);
                //   },
                //   // children: [
                //   //       ProductCard(),
                //   //   //SizedBox(width: getProportionateScreenWidth(20)),
                //   //     //   ProductCard(),
                //   //     // //  SizedBox(width: getProportionateScreenWidth(20)),
                //   //     //   ProductCard(),
                //   //     //   ProductCard(),
                //   //     //   ProductCard()
                //   //        // here by default width and height is 0
                      
                    
                //   // ],
                // ),
              ),
            )
          ],
        );
      }
    );
  }
}

