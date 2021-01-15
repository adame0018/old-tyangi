import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopSlider extends StatefulWidget {
  TopSlider({@required this.user, @required this.orientation});
  // final String uid;
  final AppUser user;
  final Orientation orientation;
  @override
  _TopSliderState createState() => _TopSliderState();
}

class _TopSliderState extends State<TopSlider> {

  PageController controller = PageController();
  int listingCount;
  // loadUser()async{
    
  //   var temp = await getUserFromId(widget.uid);
  //   setState(() {
  //     user = temp;
  //   });
  // }

  loadListingCount() async{
    var count = await getUserListingCount(widget.user.uid);
    setState(() {
      listingCount = count;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // loadUser();
    loadListingCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            children: [
              widget.orientation == Orientation.portrait ?
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 4,
                      //4
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              //"https://loremflickr.com/640/360"
                              widget.user.profilePic??"https://loremflickr.com/640/360"
                            ),
                            fit: BoxFit.cover
                          )
                        ),
                        
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(widget.user.name, 
                    style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 10),
                    RatingBarIndicator(
                      rating: widget.user.avgRating,
                      itemCount: 5,
                      itemSize: 15,
                      direction: Axis.horizontal,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,  
                      )
                    )
                  ],
                ),
              ) :
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            //"https://loremflickr.com/640/360"
                            widget.user.profilePic??"https://loremflickr.com/640/360"
                          ),
                          fit: BoxFit.cover
                        )
                      ),
                      
                    ),
                    // SizedBox(height: 10),
                    Text(widget.user.name, 
                    style: Theme.of(context).textTheme.bodyText1),
                    
                  ],
                ),
                    SizedBox(
                      height: 50,
                      child: VerticalDivider()),
                    RatingBarIndicator(
                      rating: widget.user.avgRating,
                      itemCount: 5,
                      itemSize: 15,
                      direction: Axis.horizontal,
                      itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,  
                      )
                    )
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text("Listings:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),
                        listingCount!=null ? Text("$listingCount") : Text(""),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: VerticalDivider()),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(width: 5),
                        Text(widget.user.zipCode),
                      ],
                    )
                  ],
                ),
              )
            ]
          ),
        ),
        ScrollingPageIndicator(
              dotColor: Colors.grey,
              dotSelectedColor: Colors.blue[300],
              dotSize: 6,
              dotSelectedSize: 8,
              dotSpacing: 12,
              controller: controller,
              itemCount: 2,
              orientation: Axis.horizontal,
        ),
      ],
    );
  }
}