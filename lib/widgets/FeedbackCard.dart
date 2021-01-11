import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';

class FeedbackCard extends StatelessWidget {
  FeedbackCard(
    {
      @required this.uid,
      @required this.comment,
      @required this.timeStamp,
      @required this.rating,
    }
  );
  final String uid;
  final String comment;
  final Timestamp timeStamp;
  final double rating;

  @override
  Widget build(BuildContext context) {
    
    var day = timeStamp.toDate().day;
    var month = timeStamp.toDate().month;
    var year = timeStamp.toDate().year;
    return FutureBuilder<AppUser>(
      future: getUserFromId(uid),
      builder: (context, snapshot) {
        
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
        return Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(snapshot.data.profilePic==null ? "https://firebasestorage.googleapis.com/v0/b/tyangi-18c2e.appspot.com/o/PngItem_4212617.png?alt=media&token=f350715b-249e-4316-94a1-e19083c38dc4" : 
                                snapshot.data.profilePic),
                                fit: BoxFit.cover
                              ),
                            )
                          ),
                          SizedBox(width: 5,),
                          Text(snapshot.data.name??"test"),
                        ],
                      ),
                      RatingBarIndicator(
                            rating: rating,
                            itemCount: 5,
                            itemSize: 15,
                            direction: Axis.horizontal,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,  
                            )
                          )
                    ],),
                    Divider(color: Theme.of(context).primaryColor,),
                    Text(
                      comment,
                      textAlign: TextAlign.left,
                    ),
                    Divider(color: Theme.of(context).primaryColor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("$day - $month - $year")
                      ],
                    )
                  ],
                ),
              ),  
            );
        } else {
          return SizedBox();
        }
      }
    );
  }
}