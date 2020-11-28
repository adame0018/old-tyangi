import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shop_app/models/Product.dart';

// import '../../../constants.dart';
import '../../../utitlities/sizeConfig.dart';
import '../../../models/Listing.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key key,
    @required this.listing,
    this.pressOnSeeMore,
  }) : super(key: key);

  // final Product product;
  final Listing listing;
  final GestureTapCallback pressOnSeeMore;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  int maxLines = 2;

  bool isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.listing.title,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text("\$${widget.listing.price}", style: TextStyle(fontSize: 25, color: Theme.of(context).primaryColor),)
            ],
          ),
        ),
        // SizedBox(height: 10,),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        //   child: Text("\$500", style: TextStyle(fontSize: 25, color: Theme.of(context).primaryColor),),
        // ),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            children: [
              Text("${widget.listing.category}", style: Theme.of(context).textTheme.subtitle2,),
              SizedBox(width: 5,),
              Icon(Icons.arrow_forward_ios, size: 12,),
              SizedBox(width: 5,),
              Text("${widget.listing.subCategory}", style: Theme.of(context).textTheme.subtitle2,),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text("Condition: New", style: Theme.of(context).textTheme.subtitle2,),
        ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Container(
        //     padding: EdgeInsets.all(getProportionateScreenWidth(15)),
        //     width: getProportionateScreenWidth(64),
        //     decoration: BoxDecoration(
        //       color:
        //           true ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
        //       borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(20),
        //         bottomLeft: Radius.circular(20),
        //       ),
        //     ),
        //     child: Icon(
        //       Icons.thumb_up,
        //       color:
        //           true ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
        //       size: getProportionateScreenWidth(16),
        //     ),
        //   ),
        // ),
        SizedBox(height: 30,),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: AnimatedCrossFade(
            firstChild: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
              maxLines: 2
            ), 
            secondChild: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
              maxLines: 20
            ),  
            crossFadeState: isCollapsed ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
            duration: Duration(milliseconds: 200),
          )
          // Text(
          //   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
          //   maxLines: maxLines,
          //   overflow: TextOverflow.fade,
          // ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                maxLines = isCollapsed ? 20 : 2;
                isCollapsed = !isCollapsed;
              });
              // showModalBottomSheet(
              //   // isScrollControlled: true,
              //   context: context,
              //   builder: (_) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              //       child: Column(
              //         children: [
              //           Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"),
              //         ],
              //       ),
              //     );
              //   },
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)
              //   )
              // );
            },
            child: Row(
              children: [
                Text(
                  isCollapsed ? "See More" : "See Less",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class DescriptionBox extends AnimatedWidget{

const DescriptionBox({this.description, maxLines})
: super(listenable: maxLines);

final String description;

Animation<double> get maxLines
=> listenable;

@override
Widget build(BuildContext context){
  return Text(
    description,
    maxLines: maxLines.value.toInt(),
  );
}

}