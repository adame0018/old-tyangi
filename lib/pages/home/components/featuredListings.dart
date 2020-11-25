import 'package:flutter/material.dart';
import '../../../utitlities/sizeConfig.dart';
import '../../../models/Listing.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          aspectRatio: 22/9,
                  child: Container(
            height: _height / 4.5,
            child: ListView.builder(
              itemCount: listings.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return ProductCard(listing: listings[index]);
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
    this.aspectRetio = 1.02,
    //@required this.product,
    @required this.listing
  }) : super(key: key);

  final double width, aspectRetio;
  //final Product product;
  final Listing listing;

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
          // onTap: () => Navigator.pushNamed(
          //   context,
          //   DetailsScreen.routeName,
          //   arguments: ProductDetailsArguments(product: product),
          // ),
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.005, horizontal: 10),
        // height: getProportionateScreenHeight(200),
        width: _width/2.5,//getProportionateScreenWidth(width),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [AspectRatio(
                        aspectRatio: 1.5,
                        // child: Container(
                        //   padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                        //   decoration: BoxDecoration(
                        //     color: Colors.blue.withOpacity(0.1),
                        //     borderRadius: BorderRadius.circular(15),
                        //   ),
                        //   
                        // child: Hero(
                        //     tag: listing.id,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(listing.images[0]),
                                  fit: BoxFit.cover
                                )
                              ),
                              // child: CachedNetworkImage(
                              //   imageUrl: listing.images[0],
                                
                                 
                              //   ),
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
                          color: Colors.grey.withAlpha(200),
                        ),
                        child: Text("\$"+listing.price, style: TextStyle(color: Colors.white),)
                      )
                      ]
                    ),
                    SizedBox(height: _height/120),
                    Flexible(
                                      child: Text(
                        listing.title,
                        style: TextStyle(
                          color: Colors.blue, fontSize: _height/45, 
                          fontWeight: FontWeight.w600 ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: _height/150),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: _height/70,
                        ),
                        Flexible(
                          child: Text(
                            listing.zipCode,
                            style: TextStyle(
                              fontSize: _height/70
                            ),
                            )
                          )
                      ],
                    )
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
          ),
      //   ),
      // ),
    );
  }
}