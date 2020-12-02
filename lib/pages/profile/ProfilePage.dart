import 'package:Tyangi/models/Listing.dart';
import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/pages/home/components/featuredListings.dart';
import 'package:Tyangi/pages/profile/FeedBack.dart';
import 'package:Tyangi/pages/profile/topSlider.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:Tyangi/widgets/ListingCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({@required this.uid});
  final String uid;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> 
with TickerProviderStateMixin{
  TabController _tabController;
  List<Listing> listings = List<Listing>();
  User currentUser;
  AppUser user;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  loadListings()async {
    var temp = await getListings();
    setState(() {
      
      listings.addAll(temp);
    });
  }
  loadUser() async {
    var temp = await getUserFromId(widget.uid);
    setState(() {
      user = temp;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    currentUser = FirebaseAuth.instance.currentUser;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    loadUser();
    loadListings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CupertinoNavigationBar(
        middle: Text("Profile")
      ),

      body: user == null ? Center(child: CircularProgressIndicator()) : 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: _width,
              height: _height/4,
              child: TopSlider(user: user,)
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
                                return ListingCard(listing: value, pageTag: "Profile", showMenu: value.uid == currentUser.uid);
                            }).toList(),
                          ],
                        ),
                        Flex(
                          direction: Axis.vertical,
                          children: [FeedbackPage(uid: widget.uid, scaffoldKey: _scaffoldKey,)]
                          )
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