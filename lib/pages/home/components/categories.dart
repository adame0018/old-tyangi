import 'package:Tyangi/models/Category.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utitlities/sizeConfig.dart';
import '../../subCategory/subCategories.dart';
// import 'package:marquee/marquee.dart';

class Categories extends StatelessWidget {
  Categories({
    @required this.categories,
    @required this.orientation
  });
  final List<Category> categories;
  final Orientation orientation;
  @override
  Widget build(BuildContext context) {
    
    var _width = MediaQuery.of(context).size.width;
    // List<Map<String, dynamic>> categories = [
    //   {"icon": "assets/icons/Flash Icon.svg", "text": "Flash Deal"},
    //   {"icon": "assets/icons/Bill Icon.svg", "text": "Bill"},
    //   {"icon": "assets/icons/Game Icon.svg", "text": "Game"},
    //   {"icon": "assets/icons/Gift Icon.svg", "text": "Daily Gift"},
    //   {"icon": "assets/icons/Discover.svg", "text": "More"},
    // ];
        var _height = MediaQuery.of(context).size.height;
        if(orientation == Orientation.portrait){

          return Container(
            height:_height/8,//getProportionateScreenHeight(140),
            // padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: categories.isEmpty ? CircularProgressIndicator() : 
              ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  categories.length,
                  (index) {
                    
                    return AspectRatio(
                      aspectRatio: 0.82,
                    // margin: EdgeInsets.symmetric(horizontal: 5),
                    child: CategoryCard(
                      text: categories[index].name,
                      orientation: orientation,
                      press: () {
              // List<String> subCategories = List<String>();
              // subCategories.addAll(await getSubCategories(categories[index]));
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => SubCategories(categories[index].name,))
                );
                      },
                    ),
                  );
                  }
                ),
            ),
          );
        } else {
           return Container(
            height:_height/5,//getProportionateScreenHeight(140),
            // padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: categories.isEmpty ? CircularProgressIndicator() : 
              ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  categories.length,
                  (index) {
                    
                    return AspectRatio(
                      aspectRatio: 1,
                    // margin: EdgeInsets.symmetric(horizontal: 5),
                    child: CategoryCard(
                      text: categories[index].name,
                      orientation: orientation,
                      press: () {
              // List<String> subCategories = List<String>();
              // subCategories.addAll(await getSubCategories(categories[index]));
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => SubCategories(categories[index].name,))
                );
                      },
                    ),
                  );
                  }
                ),
            ),
          );
        }
      }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    this.icon,
    @required this.text,
    @required this.press,
    @required this.orientation
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
        return GestureDetector(
          onTap: press,
          child: SizedBox(
            // width: _width/4.8,
            child: Column(
              children: [
                Container(
                  
                  padding: EdgeInsets.all(orientation == Orientation.portrait ? _height/50 : _height/25),
                  // height: getProportionateScreenWidth(55),
                  // width: getProportionateScreenWidth(55),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withAlpha(100),
                      width: 2.0
                    ),
                    // color: Theme.of(context).primaryColor.withAlpha(100),
                    // borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.car_detailed,
                      color: Theme.of(context).primaryColor,),
                  )
                ),
                SizedBox(height: 5),
                Flexible(
                    child: Text(text, 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: orientation == Orientation.portrait ? _height/60 : _height/30
                      ),
                    // overflow: TextOverflow.ellipsis
                  ),
                )
              ],
            ),
          ),
        );
      }
}