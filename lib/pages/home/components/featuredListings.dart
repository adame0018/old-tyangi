import 'package:Tyangi/widgets/ListingCard.dart';
import 'package:flutter/material.dart';
import '../../../utitlities/sizeConfig.dart';
import '../../../models/Listing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../details/details_screen.dart';

class FeaturedListings extends StatelessWidget {
  FeaturedListings({
    @required this.listings,
    @required this.title
  });
  final List<Listing> listings;
  final String title;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Text(title, style: TextStyle(fontSize: _height/40, fontWeight: FontWeight.w700 ),),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        AspectRatio(
          aspectRatio: 21.5/9,
                  child: Container(
            // height: _height / 3.5,
            child: ListView.builder(
              itemCount: listings.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return ListingCard(listing: listings[index], pageTag: "Home",);
              },
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
        )
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.width = 160,
    this.aspectRatioImage = 1.35,
    this.aspectRatioCard = 1,
    this.fontSizeMultiple =1,
    @required this.pageTag,
    //@required this.product,
    @required this.listing
  }) : super(key: key);

  final double width, aspectRatioCard, aspectRatioImage, fontSizeMultiple;
  //final Product product;
  final Listing listing;
  final String pageTag;
  static const List<String> menuChoices = ["Mark as Sold", "Renew", "Promote"];

  handleSelect(choice){
    switch(choice){
      case "Mark as Sold":
        print("Mark as Sold");
        break;
      case "Renew":
        print("Renew");
        break;
      case "Promote":
        print("Promote");
        break;

    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return 
    //Padding(
      
    //   padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
    //   child: SizedBox(
    //     width: getProportionateScreenWidth(width),
    //     child: 
    GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailsScreen(listing: listing, pageTag: pageTag,))),
          // Navigator.pushNamed(
          //   context,
          //   DetailsScreen.routeName,
          //   arguments: ProductDetailsArguments(product: product),
          // ),
      child: AspectRatio(
        aspectRatio: aspectRatioCard,
        // margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.005, horizontal: 10),
        // height: getProportionateScreenHeight(200),
        // width: _width/2.5,//getProportionateScreenWidth(width),
        // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      //       decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(15),
      //   boxShadow: [BoxShadow(
      //     spreadRadius: 3.0,
      //     blurRadius: 4.0,
      //     offset: Offset(1,2),
      //     color: Colors.grey.withOpacity(0.3)
      //   )]
      // ),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [AspectRatio(
                      aspectRatio: aspectRatioImage,
                      // child: Container(
                      //   padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                      //   decoration: BoxDecoration(
                      //     color: Colors.blue.withOpacity(0.1),
                      //     borderRadius: BorderRadius.circular(15),
                      //   ),
                      //   
                      // child: Hero(
                      //     tag: listing.id,
                          child: Hero(
                            tag: listing.id+pageTag,
                            child: Container(
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(12),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                  color: Colors.grey.withOpacity(0.5),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(listing.images[0]),
                                    fit: BoxFit.cover
                                  )
                                ),
                                // child: CachedNetworkImage(
                                //   imageUrl: listing.images[0],
                                  
                                   
                                //   ),
                              ),
                          )
                          //Image.network(listing.images[0]),
                        //),
                      //),
                    ),
                    Container(
                      // width: 50,
                      // height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withAlpha(180),
                      ),
                      child: Text("\$"+listing.price, style: TextStyle(color: Colors.white, fontSize: _height/50*fontSizeMultiple),)
                    ),
                    
                    ]
                  ),
                  SizedBox(height: _height/220),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            listing.title,
                            style: TextStyle(
                              color: Colors.blue, fontSize: (_height/45)*fontSizeMultiple, 
                              fontWeight: FontWeight.w600 ),
                            maxLines: 2,
                          ),
                      
                    // SizedBox(height: _height/150),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.location_on,
                    //       size: _height/70,
                    //     ),
                    //     Text(
                    //       listing.zipCode,
                    //       style: TextStyle(
                    //         fontSize: (_height/70)*fontSizeMultiple
                    //       ),
                    //       )
                    //   ],
                    // )
                    ],
                    ),
                  ),
                  SizedBox(height: _height/350),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: _height/70,
                          ),
                          Text(
                            listing.zipCode,
                            style: TextStyle(
                              fontSize: (_height/70)*fontSizeMultiple
                            ),
                            )
                        ],
                      ),
                  ),
                   SizedBox(height: _height/250),
                  // SizedBox(
                  //   height: 30,
                  //   width: 30,
                  //   child: 
                  // Align(
                  //   alignment: Alignment(0.5, -1),
                  //   heightFactor: 0.001,
                  //   child: PopupMenuButton(
                  //       onSelected: handleSelect,
                  //       itemBuilder: (context){
                  //         menuChoices.map(
                  //           (choice) => PopupMenuItem (
                  //             value: choice,
                  //             child: Text(choice),
                  //             )
                  //         );
                  //       }
                  //     ),
                  // ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "\$${listing.price}",
                  //       style: TextStyle(
                  //         fontSize: getProportionateScreenWidth(18),
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //     InkWell(
                  //       borderRadius: BorderRadius.circular(50),
                  //       onTap: () {},
                  //       // child: Container(
                  //       //   padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                  //       //   height: getProportionateScreenWidth(28),
                  //       //   width: getProportionateScreenWidth(28),
                  //       //   decoration: BoxDecoration(
                  //       //     color: Colors.blue.withOpacity(0.1),
                  //       //     shape: BoxShape.circle,
                  //       //   ),
                  //       //   
                  //       child: Icon(Icons.library_add_check)
                  //         // SvgPicture.asset(
                  //         //   "assets/icons/Heart Icon_2.svg",
                  //         //   color: product.isFavourite
                  //         //       ? Color(0xFFFF4848)
                  //         //       : Color(0xFFDBDEE4),
                  //         // ),
                  //       ),
                  //     // ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
      //   ),
      // ),
    );
  }
}