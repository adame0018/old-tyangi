import 'package:Tyangi/models/appUser.dart';
import 'package:flutter/material.dart';
// import 'package:shop_app/components/default_button.dart';
// import 'package:shop_app/models/Product.dart';
import '../../../utitlities/sizeConfig.dart';
import '../../../widgets/Inputs.dart';
import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/Listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utitlities/firebase.dart';

class Body extends StatelessWidget {
  // final Product product;
  const Body({Key key,
   @required this.listing
  }) : super(key: key);
  final Listing listing;

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // SizedBox(height: 20),
        ProductImages(listing: listing,),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                listing: listing,
                pressOnSeeMore: () {},
              ),
              // SizedBox(height: 10,),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: submitButton(context: context, hint: "Chat", onSubmit: () {
                  
                },),
              ),
              UserDetails(listing: listing,),
              SizedBox(height: 10)
            ],
          ),
        ),
      ],
    );
  }
}

class UserDetails extends StatelessWidget {
  UserDetails({
    @required this.listing
  });

  final Listing listing;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserFromId(listing.uid),
        builder: (context, snap)
        {
          if(snap.connectionState == ConnectionState.done && snap.hasData){
            AppUser user = snap.data;

          return Container(
          
            padding: EdgeInsets.all(6),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              // border: Border(top: BorderSide(width: 1, color: Colors.grey), bottom: BorderSide(width: 1, color: Colors.grey))
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 3,
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // border: Border.all(width: 0.5),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(user.profilePic),
                        fit: BoxFit.fill
                      )
                    ),
                    ),
                    SizedBox(width: 10,),
                    Text("${user.name}", style: Theme.of(context).textTheme.headline5,),
                  ],
                ),
                Row(
                      children: [
                        Text(
                          "3.0",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                      Icon(Icons.star, color: Colors.yellow,),
                      ],
                    ),
              ],
            ),
          );
          } else{
            return SizedBox();
          }
      }
    );
  }
}
