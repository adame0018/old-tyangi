import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/pages/chat/chat.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chat_demo/chat.dart';
// import 'package:flutter_chat_demo/const.dart';
// import 'package:flutter_chat_demo/settings.dart';
// import 'package:flutter_chat_demo/widget/loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'main.dart';

class ChatList extends StatefulWidget {
  // final String currentUserId;

  ChatList({Key key}) : super(key: key);

  @override
  State createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  ChatListState({Key key});

  String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    currentUserId = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
  firebaseMessaging.requestNotificationPermissions();

  firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
    print('onMessage: $message');
    Platform.isAndroid
        ? showNotification(message['notification'])
        : showNotification(message['aps']['alert']);
    return;
  }, onResume: (Map<String, dynamic> message) {
    print('onResume: $message');
    return;
  }, onLaunch: (Map<String, dynamic> message) {
    print('onLaunch: $message');
    return;
  });

  firebaseMessaging.getToken().then((token) {
    print('token: $token');
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .update({'pushToken': token});
  }).catchError((err) {
    // Fluttertoast.showToast(msg: err.message.toString());
  });
}

  // void registerNotification() {
  //   firebaseMessaging.requestNotificationPermissions();

  //   firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
  //     print('onMessage: $message');
  //     Platform.isAndroid
  //         ? showNotification(message['notification'])
  //         : showNotification(message['aps']['alert']);
  //     return;
  //   }, onResume: (Map<String, dynamic> message) {
  //     print('onResume: $message');
  //     return;
  //   }, onLaunch: (Map<String, dynamic> message) {
  //     print('onLaunch: $message');
  //     return;
  //   });

  //   firebaseMessaging.getToken().then((token) {
  //     print('token: $token');
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUserId)
  //         .update({'pushToken': token});
  //   }).catchError((err) {
  //     Fluttertoast.showToast(msg: err.message.toString());
  //   });
  // }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('launch_background');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // void onItemMenuPress(Choice choice) {
  //   if (choice.title == 'Log out') {
  //     handleSignOut();
  //   } else {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => ChatSettings()));
  //   }
  // }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.hosting.tyangi.TyangiApp'
          : 'com.tyangi',
      'Tyangi',
      'Message',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

   print(message['body'].toString());
   print(json.encode(message));
   

    await FlutterLocalNotificationsPlugin().show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // heroTag: 'chat',
        // transitionBetweenRoutes: true,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.headline6,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          // List
          Container(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('ChatRooms').where('users', arrayContains: FirebaseAuth.instance.currentUser.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                  );
                } else {
                  print(snapshot.hasData);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),

          // Loading
          Positioned(
            child: isLoading ? CircularProgressIndicator() : Container(),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    // if (document.data()['id'] == currentUserId) {
    //   return Container();
    // } else {
      return FutureBuilder<AppUser>(
        future: getUserFromId(document.data()['users'][0] == currentUserId ? document.data()['users'][1] : document.data()['users'][0]),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return SizedBox();
          }
          else{

            return Container(
              child: FlatButton(
                child: Row(
                  children: <Widget>[
                    Material(
                      child: snapshot.data.profilePic != null
                          ? CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                                width: 50.0,
                                height: 50.0,
                                padding: EdgeInsets.all(15.0),
                              ),
                              imageUrl: snapshot.data.profilePic,
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: Colors.grey,
                            ),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    Flexible(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '${snapshot.data.name}',
                                style: TextStyle(color: Colors.black),
                              ),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Chat(
                                peerId: snapshot.data.uid,
                                peerAvatar: snapshot.data.profilePic,
                                peerName: snapshot.data.name,
                                groupChatId: document.data()['id'],
                              )));
                },
                color: Colors.grey.withAlpha(120),
                padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
            );
          }
        }
      );
    // }
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
