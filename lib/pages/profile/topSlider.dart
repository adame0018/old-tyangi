import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopSlider extends StatelessWidget {
  PageController controller = PageController();
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
                              "https://loremflickr.com/640/360"
                            ),
                            fit: BoxFit.contain
                          )
                        ),
                        
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Sufyan", style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 10),
                    RatingBarIndicator(
                      rating: 3,
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
                        Text("Location"),
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