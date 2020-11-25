import 'dart:io';

import 'package:Tyangi/pages/addListing.dart';
import 'package:Tyangi/pages/subCategory/subCategories.dart';
import 'package:async/async.dart';

import 'package:Tyangi/pages/home/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = <Widget>[
      homePage,
      // Center(
      //   child: Text(
      //     'Index 1: Business',
      //     style: optionStyle,
      //   ),
      // ),
      SubCategories(),
      Center(
        child: Text(
          'Index 2: School',
          style: optionStyle,
        ),
      ),
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