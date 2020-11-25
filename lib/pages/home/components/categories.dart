import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utitlities/sizeConfig.dart';
// import 'package:marquee/marquee.dart';

class Categories extends StatelessWidget {
  Categories({
    @required this.categories
  });
  final List<String> categories;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    // List<Map<String, dynamic>> categories = [
    //   {"icon": "assets/icons/Flash Icon.svg", "text": "Flash Deal"},
    //   {"icon": "assets/icons/Bill Icon.svg", "text": "Bill"},
    //   {"icon": "assets/icons/Game Icon.svg", "text": "Game"},
    //   {"icon": "assets/icons/Gift Icon.svg", "text": "Daily Gift"},
    //   {"icon": "assets/icons/Discover.svg", "text": "More"},
    // ];
    return Container(
      height: _height/8,//getProportionateScreenHeight(140),
      // padding: EdgeInsets.all(getProportionateScreenWidth(15)),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: categories.isEmpty ? CircularProgressIndicator() : 
        CupertinoScrollbar(
          
                  child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            categories.length,
            (index) => Container(
              // margin: EdgeInsets.symmetric(horizontal: 5),
              child: CategoryCard(
                icon: categories[index],
                text: categories[index],
                press: () {},
              ),
            ),
          ),
      ),
        ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: _width/4.8,
        child: Column(
          children: [
            Container(
              
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
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
              child: Icon(
                CupertinoIcons.car_detailed,
                color: Theme.of(context).primaryColor,)
            ),
            SizedBox(height: 5),
            Flexible(
                child: Text(text, textAlign: TextAlign.center,
                // overflow: TextOverflow.ellipsis
              ),
            )
          ],
        ),
      ),
    );
  }
}