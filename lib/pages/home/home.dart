import 'dart:io';

import 'package:Tyangi/pages/addListing.dart';
import 'package:Tyangi/pages/chat/chatList.dart';
import 'package:Tyangi/pages/profile/ProfilePage.dart';
import 'package:Tyangi/pages/settings/settings.dart';
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
import 'package:purchases_flutter/purchases_flutter.dart';
import '../details/details_screen.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


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
  PurchaserInfo _purchaserInfo;
  Offering _offer;
  Package _package;
  String bought = 'not bought';

  loadCsv() async{
    final myData = await rootBundle.loadString('assets/zips.json');
    List jsonData = json.decode(myData);
    // print(jsonData[0]);
    var result = jsonData.singleWhere((element) => element['zip code'] == '35006');
    // print(result);
    //List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);

    
    //print(csvTable);
  }

  postGeopoints() async {
    GeoFirePoint point = Geoflutterfire().point(latitude: 33.592585, longitude: -86.95969);
    await FirebaseFirestore.instance.collection('Listings').doc('QX1Iq27RE3D6RX1WThEe').update({
      'position': point.data
    });
    // print("updated");
  }

  getLatLong() async{
    final response = await http.get('http://open.mapquestapi.com/geocoding/v1/address?key=CykCSSAevR7sVckyegrSwJAZI3oTDavz&postalCode=1234&maxResults=1&thumbMaps=false');
    if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> result = jsonDecode(response.body);
    // print(result['results'][0]['locations'][0]['latLng']['lat']);
    // var lat = result['lat'];
    // var long = result['lng'];
    // geoPoint = Geoflutterfire().point(latitude: lat, longitude: long);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    // showSnackBar("Invalid zipCode");
    print("error");
    return;
  }
  }

  setupPurchases() async {
    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
    } on PlatformException catch (e) {
      print(e);
    }

    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        // Display current offering with offerings.current
        Offering offer  = offerings.all['test_offering'];
        if(offer!=null){
          if (!mounted) return;
          setState(() {
            _offer = offer;
            _package = offer.getPackage('tokens-10');
          });
        }
    }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      // _offerings = offerings;
    });
    
  
  }

  buy() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(_package);
      
      // var isPro = purchaserInfo.entitlements.all["auto_post_test"].isActive;
      // print("PRooo: $isPro");
      // if (isPro) {
      //   // Unlock that great "pro" content
      //   setState(() {
      //     bought = 'You have bought tokens';
      //   });
      // }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        // showSnackbar(e);
        print("Error $e");             
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setupPurchases();
    _pages = <Widget>[
      homePage,

      ProfilePage(uid: FirebaseAuth.instance.currentUser.uid, fromHome: true,),
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       OutlinedButton(
      //         child: Text('get loc'),
      //         onPressed: buy,
      //       ),
      //       SizedBox(height: 10,),
      //       Text(bought),
      //       _purchaserInfo.entitlements.all["auto_post_test"].isActive ? Text("isPro"): Text("NotPro")
      //     ],
      //   ),
      // ),
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
      SettingsPage()
      // Center(child: Text("settings"),)
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
          child: ImageIcon(
            AssetImage('assets/icons/add.png'),
          ),
          tooltip: "Add Listing", 
            
          
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
                  Transform.scale(
                    scale: 0.8,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/home.png',
                        color: _selectedPage == 0 ? Colors.blue : Colors.black,
                        filterQuality: FilterQuality.high,
                      ),
                      focusColor: Colors.blue,
                      iconSize: 10,
                      onPressed: () {
                        setState((){
                          _selectedPage = 0;
                        });
                      },
                      highlightColor: Colors.blue,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/user.png',
                        color: _selectedPage == 1 ? Colors.blue : Colors.black, 
                        filterQuality: FilterQuality.high,
                      ),
                      onPressed: () {
                      setState((){
                        _selectedPage = 1;
                      });
                    }),
                  ),
                  SizedBox(width: 40), // The dummy child
                  Transform.scale(
                    scale: 0.8,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/conversation.png',
                        color: _selectedPage == 2 ? Colors.blue : Colors.black, 
                        filterQuality: FilterQuality.high,
                      ),
                    onPressed: () {
                      setState((){
                        _selectedPage = 2;
                      });
                    }),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/settings.png',
                      color: _selectedPage == 3 ? Colors.blue : Colors.black,   
                      filterQuality: FilterQuality.high,
                      ),
                    onPressed: () {
                      setState((){
                        _selectedPage = 3;
                      });
                    }),
                  ),
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