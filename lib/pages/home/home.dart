import 'dart:io';

import 'package:Tyangi/pages/addListing.dart';
import 'package:Tyangi/pages/chat/chatList.dart';
import 'package:Tyangi/pages/profile/ProfilePage.dart';
import 'package:Tyangi/pages/subCategory/subCategories.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:Tyangi/utitlities/zipCodes.dart';
import 'package:Tyangi/widgets/InfiniteGridView.dart';
import 'package:Tyangi/widgets/ListingCard.dart';
import 'package:async/async.dart';

import 'package:Tyangi/pages/home/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../details/details_screen.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:convert';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user;
  int _selectedPage = 0;
  Widget homePage = HomePage();
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _pages;
  PageController _pageController;

  loadCsv() async{
    final myData = await rootBundle.loadString('assets/zips.json');
    List jsonData = json.decode(myData);
    print(jsonData[0]);
    var result = jsonData.singleWhere((element) => element['zip code'] == '35006');
    print(result);
    //List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);

    
    //print(csvTable);
  }

  postGeopoints() async {
    GeoFirePoint point = Geoflutterfire().point(latitude: 33.592585, longitude: -86.95969);
    await FirebaseFirestore.instance.collection('Listings').doc('QX1Iq27RE3D6RX1WThEe').update({
      'position': point.data
    });
    print("updated");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = <Widget>[
      homePage,

      // ProfilePage(uid: FirebaseAuth.instance.currentUser.uid, fromHome: true,),
      Center(
        child: Text(
          'Index 1: Business',
          style: optionStyle,
        ),
      ),
      // DetailsScreen(),
      // GridView.count(
      //   crossAxisCount: 2,
      //   children: [
      //     ListingCard(),
      //     ListingCard(),
      //     ListingCard(),
      //     ListingCard(),
      //   ],
      // )
      // Center(
      //   child: Text("Messages")
      // ),
      ChatList(),
      Center(child: Text("settings"),)
    ];
    _pageController = PageController();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      
    });
    // _pageController.animateToPage(index,
    //           duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              Platform.isAndroid ?
              MaterialPageRoute(builder: (_)=> AddListing())
              :
              CupertinoPageRoute(builder: (_)=>AddListing())
            );
          },
          child: Icon(Icons.add),
          
            
          
        ),
        body: WillPopScope(
        onWillPop: _onBackPressed,
          child: IndexedStack(
        
        //     child: Center(
        //       child: _pages.elementAt(_selectedPage)
        // ),
            children: _pages,
            index: _selectedPage,
            // controller: _pageController,
            // onPageChanged: (index) {
            //   setState(() => _selectedPage = index);
            // },
          ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(icon: Icon(
                    Icons.home,
                    color: _selectedPage == 0 ? Colors.blue : Colors.black,
                    ), 
                    onPressed: () {
                      setState((){
                        _selectedPage = 0;
                      });
                    },
                    highlightColor: Colors.blue,
                  ),
                  IconButton(icon: Icon(
                      Icons.person,
                      color: _selectedPage == 1 ? Colors.blue : Colors.black,
                      ), 
                    onPressed: () {
                    setState((){
                      _selectedPage = 1;
                    });
                  }),
                  SizedBox(width: 40), // The dummy child
                  IconButton(icon: Icon(
                    Icons.message,
                    color: _selectedPage == 2 ? Colors.blue : Colors.black,
                    ), 
                  onPressed: () {
                    setState((){
                      _selectedPage = 2;
                    });
                  }),
                  IconButton(icon: Icon(
                    Icons.menu,
                    color: _selectedPage == 3 ? Colors.blue : Colors.black,
                    ), 
                  onPressed: () {
                    setState((){
                      _selectedPage = 3;
                    });
                  }),
                ],
              ),
            )
      )
    //BottomNavigationBar(
    //     showUnselectedLabels: false,
    //   items: const <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: 'Home',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.message_rounded),
    //       label: 'Messages',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.menu),
    //       label: 'Settings',
    //     ),
    //   ],
    //   currentIndex: _selectedPage,
    //   selectedItemColor: Colors.blue[300],
    //   onTap: _onItemTapped,
    // ),
    );
  }

  Future<bool> _onBackPressed() {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit an App'),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text("NO"),
        ),
        SizedBox(height: 16),
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(true),
          child: Text("YES"),
        ),
      ],
    ),
  ) ??
      false;
}
}