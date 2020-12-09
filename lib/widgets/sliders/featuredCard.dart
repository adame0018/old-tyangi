import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/pages/details/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FeaturedCard extends StatefulWidget {
  const FeaturedCard({
    Key key,
    this.width = 160,
    this.aspectRatioImage = 1.35,
    this.aspectRatioCard = 1,
    this.fontSizeMultiple =1,
    @required this.pageTag,
    // @required this.listing,
    this.showMenu = false,
  }) : super(key: key);

  final double width, aspectRatioCard, aspectRatioImage, fontSizeMultiple;
  // final Listing listing;
  final String pageTag;
  static const List<String> menuChoices = ["Mark as Sold", "Renew", "Promote"];
  final bool showMenu;

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  bool enableRenew;
  handleSelect(choice){
    switch(choice){
      case "Mark as Sold":
        print("Mark as Sold");
        // FirebaseFirestore.instance.collection('Listings').doc(widget.listing.id).update({
        //   'sold': true,
        // });
        break;
      case "Renew":
        print("Renew");
        // FirebaseFirestore.instance.collection('Listings').doc(widget.listing.id).update({
        //   'createdAt': FieldValue.serverTimestamp(),
        // });
        setState(() {
          enableRenew = false;
        });
        break;
      case "Promote":
        print("Promote");
        break;

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          onTap: (){
            print("tapped");
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