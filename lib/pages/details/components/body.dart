import 'dart:io';

import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/pages/chat/chat.dart';
import 'package:Tyangi/pages/profile/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:shop_app/components/default_button.dart';
// import 'package:shop_app/models/Product.dart';
import '../../../utitlities/sizeConfig.dart';
import '../../../widgets/Inputs.dart';
import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/Listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utitlities/firebase.dart';

class Body extends StatefulWidget {
  // final Product product;
  const Body({Key key,
   @required this.listing,
   @required this.pageTag
  }) : super(key: key);
  final Listing listing;
  final String pageTag;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLoading = false;

  openChat({String peerId, BuildContext context}) async{
    String currentUser =  FirebaseAuth.instance.currentUser.uid;
    var chat = await FirebaseFirestore.instance.collection('Users/$currentUser/Chats').doc(peerId).get();
    if(chat.exists){
      print("it exists");
      var peerUser = await getUserFromId(peerId);
      Navigator.of(context).push(
        MaterialPageRoute(
        builder: (_) => Chat(
          peerId: peerId, 
          peerAvatar: peerUser.profilePic, 
          groupChatId: chat.data()['chatRoom']
          )
        )
      );
    }else {
      setState(() {
        _isLoading = true;
      });
      var chatRoom = FirebaseFirestore.instance.collection('ChatRooms').doc();
      await chatRoom.set({
        'id': chatRoom.id,
        'users': [currentUser, peerId],
      });
      await FirebaseFirestore.instance.collection('ChatRooms/${chatRoom.id}/Messages').doc('empty').set({
        'content': ''
      });
      await FirebaseFirestore.instance.collection('Users/$currentUser/Chats').doc(peerId).set({
        'chatRoom': chatRoom.id
      });
      await FirebaseFirestore.instance.collection('Users/$peerId/Chats').doc(currentUser).set({
        'chatRoom': chatRoom.id
      });
      var peerUser = await getUserFromId(peerId);
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Navigator.of(context).push(
        MaterialPageRoute(
        builder: (_) => Chat(
          peerId: peerId, 
          peerAvatar: peerUser.profilePic, 
          groupChatId: chatRoom.id
          )
        )
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // SizedBox(height: 20),
        ProductImages(listing: widget.listing,pageTag: widget.pageTag,),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                listing: widget.listing,
                pressOnSeeMore: () {},
              ),
              // SizedBox(height: 10,),
              widget.listing.uid != FirebaseAuth.instance.currentUser.uid ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: submitButton(context: context, hint: "Chat", isLoading: _isLoading,onSubmit: () async{
                  await openChat(peerId: widget.listing.uid, context: context);
                },),
              ) : SizedBox(height: _height/8,),
              UserDetails(listing: widget.listing,),
              SizedBox(height: 10)
            ],
          ),
        ),
      ],
    );
  }
}

class UserDetails extends StatelessWidget {
  UserDetails({
    @required this.listing
  });

  final Listing listing;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserFromId(listing.uid),
        builder: (context, snap)
        {
          if(snap.connectionState == ConnectionState.done && snap.hasData){
            AppUser user = snap.data;

          return InkWell(

            onTap: (){
              Platform.isAndroid ? 
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfilePage(uid: user.uid))) :
                Navigator.of(context).push(CupertinoPageRoute(builder: (_) => ProfilePage(uid: user.uid)));
            },
            child: Container(
              padding: EdgeInsets.all(6),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                // border: Border(top: BorderSide(width: 1, color: Colors.grey), bottom: BorderSide(width: 1, color: Colors.grey))
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // border: Border.all(width: 0.5),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(user.profilePic),
                          fit: BoxFit.cover
                        )
                      ),
                      ),
                      SizedBox(width: 10,),
                      Text("${user.name}", style: Theme.of(context).textTheme.headline5,),
                    ],
                  ),
                  Row(
                        children: [
                          Text(
                            user.avgRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                        Icon(Icons.star, color: Colors.yellow,),
                        ],
                      ),
                ],
              ),
            ),
          );
          } else{
            return SizedBox();
          }
      }
    );
  }
}
