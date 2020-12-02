import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopSlider extends StatefulWidget {
  TopSlider({@required this.user});
  // final String uid;
  final AppUser user;
  @override
  _TopSliderState createState() => _TopSliderState();
}

class _TopSliderState extends State<TopSlider> {

  PageController controller = PageController();

  // loadUser()async{
    
  //   var temp = await getUserFromId(widget.uid);
  //   setState(() {
  //     user = temp;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    // loadUser();
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
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              //"https://loremflickr.com/640/360"
                              widget.user.profilePic
                            ),
                            fit: BoxFit.contain
                          )
                        ),
                        
                      ),
                    ),
                    SizedBox(height: 20),
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
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text("Listings:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),
                        Text("12"),
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