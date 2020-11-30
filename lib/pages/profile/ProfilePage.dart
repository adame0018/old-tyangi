import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/pages/home/components/featuredListings.dart';
import 'package:Tyangi/pages/profile/topSlider.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> 
with TickerProviderStateMixin{
  TabController _tabController;
  List<Listing> listings = List<Listing>();

  loadListings()async {
    var temp = await getListings();
    setState(() {
      
      listings.addAll(temp);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    loadListings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Profile")
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: _width,
              height: _height/4,
              child: TopSlider()
            ),
            Expanded(
                          child: Column(
                children: [
                  Container(
                    height: 50,
                    child: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(child: Text("Listings", style: TextStyle(color: Colors.blue),),),
                        Tab(child: Text("Feedback", style: TextStyle(color: Colors.blue),))
                      ]
                    ),
                  ),
                  Expanded(
                    // height: _height-50 - (_height/3.5),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          //itemCount: listings.length,
                          scrollDirection: Axis.vertical,
                          // // itemBuilder: (context, index){
                          //   return ProductCard(listing: listings[index]);
                          // }
                          children: [
                            ...listings.map((value) {
                                return ProductCard(listing: value, pageTag: "Profile",);
                            }).toList(),
                          ],
                        ),
                        Text("Feedback",)
                      ]
                    ),
                  ),
                ],
              ),
            )
          ]
        ),
      )
    );
  }
}