import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/pages/details/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ListingCard extends StatefulWidget {
  const ListingCard({
    Key key,
    this.width = 160,
    this.aspectRatioImage = 1.35,
    this.aspectRatioCard = 1,
    this.fontSizeMultiple =1,
    @required this.pageTag,
    @required this.listing,
    this.showMenu = false,
  }) : super(key: key);

  final double width, aspectRatioCard, aspectRatioImage, fontSizeMultiple;
  final Listing listing;
  final String pageTag;
  static const List<String> menuChoices = ["Mark as Sold", "Renew", "Promote"];
  final bool showMenu;

  @override
  _ListingCardState createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  bool enableRenew;
  handleSelect(choice){
    switch(choice){
      case "Mark as Sold":
        print("Mark as Sold");
        FirebaseFirestore.instance.collection('Listings').doc(widget.listing.id).update({
          'sold': true,
        });
        break;
      case "Renew":
        print("Renew");
        FirebaseFirestore.instance.collection('Listings').doc(widget.listing.id).update({
          'createdAt': FieldValue.serverTimestamp(),
        });
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
    enableRenew = Timestamp.now().toDate().difference(widget.listing.createdAt.toDate()).inHours >= 6;
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
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailsScreen(listing: widget.listing, pageTag: widget.pageTag,)));
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AspectRatio(
                        aspectRatio: widget.aspectRatioImage,
                        child: Hero(
                          tag: widget.listing.id+widget.pageTag,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                color: Colors.grey.withOpacity(0.5),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(widget.listing.images[0]),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                  ),
                ),
                
              ),
              Positioned(
                bottom: 7,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: _height/20,),
                    Text(widget.listing.title, 
                      style: TextStyle(fontSize: (_height/45)*widget.fontSizeMultiple, 
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500
                              ),
                      ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: _height/70,),
                        Text("location", 
                          style: TextStyle(
                              fontSize: (_height/70)*widget.fontSizeMultiple
                            )
                          )
                      ],
                    )
                  ],
                )
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withAlpha(180),
                        ),
                        child: Text("\$"+widget.listing.price, style: TextStyle(color: Colors.white, fontSize: (_height/50)*widget.fontSizeMultiple),)
                      ),
              ),
              if (widget.showMenu)
              Positioned(
                bottom: 0,
                right: 0,
                child: PopupMenuButton<String>(
                            onSelected: (value){
                              handleSelect(value);
                            },
                            itemBuilder: (context){
                              return ListingCard.menuChoices.map(
                                (choice) {
                                  // bool enabled = true;
                                  // if(choice == 'Renew'){
                                  //   if(Timestamp.now().toDate().difference(widget.listing.createdAt.toDate()).inHours >= 6){
                                  //     enabled = true;
                                  //   } else {
                                  //     enabled = false;
                                  //   }
                                  // }
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                    enabled: choice == 'Renew' ? enableRenew : true,
                                  );
                                }
                              ).toList();
                            }
                          ),
              ),

            ]
          ),
        ),
      ),
    );
  }
}