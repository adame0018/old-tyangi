import 'package:Tyangi/models/rating.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:Tyangi/widgets/FeedbackCard.dart';
import 'package:Tyangi/widgets/Inputs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage(
    {
      @required this.uid,
      @required this.scaffoldKey
    }
  );
  final String uid;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _commentController;
  double rating;
  bool isLoading = false;
  List<Rating> feedbacks = List<Rating>();
  bool canReview = false;

  checkReview() async {
    if(widget.uid == FirebaseAuth.instance.currentUser.uid){
      setState(() {
        canReview = false;
      });
      return ;
    }
    var snap = await FirebaseFirestore.instance.collection('Users/${widget.uid}/ratings').where('userId',isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    if(snap.size > 0){
      setState(() {
        canReview = false;
      });
    } else{
      setState(() {
        canReview = true;
      });
    }
  }

  
  @override
  void initState() {
    _commentController = TextEditingController();
    rating = 0;
    checkReview();
    super.initState();
  }

  

  _bottomSheet(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
            child: Column(
              children: [
                Text("Leave Feedback", style: Theme.of(context).textTheme.headline4,),
                SizedBox(height: 20),
                RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemSize:   30,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (thisRating) {
                      print(thisRating);
                      setState(() {
                        rating = thisRating;
                      });
                    },
                  ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: _commentController,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 200,
                  placeholder: "Comment",
                  keyboardType: TextInputType.multiline,
                ),
                submitButton(
                    hint: "Submit",
                    isLoading: isLoading,
                    onSubmit: 
                      (){
                        if(_commentController.text.isEmpty || rating == 0){
                          widget.scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text("Please enter a star rating and comment both"),)
                          );
                          return;
                        }
                        print("submitting rating");
                        print(rating);
                        setState(() {
                          isLoading = true;
                        });
                        Rating newRating = Rating.fromUserInput(rating: rating, comment: _commentController.text, uid: FirebaseAuth.instance.currentUser.uid);
                        addRating(uid: widget.uid, rating: newRating);
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                      },
                    context: context
                  )
              ],
            ),
          ),
        ));
    });
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true, 
    //   builder: (_) {
    //     return SingleChildScrollView(
    //       child: Container(
    //         padding: EdgeInsets.only(
    //                 bottom: MediaQuery.of(context).viewInsets.bottom),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Text("Leave a Feedback", style: Theme.of(context).textTheme.headline4,),
    //             SizedBox(height: 30),
    //             RatingBar.builder(
    //               initialRating: 3,
    //               minRating: 1,
    //               direction: Axis.horizontal,
    //               allowHalfRating: true,
    //               itemCount: 5,
    //               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
    //               itemSize:   30,
    //               itemBuilder: (context, _) => Icon(
    //                 Icons.star,
    //                 color: Colors.amber,
    //               ),
    //               onRatingUpdate: (rating) {
    //                 print(rating);
    //               },
    //             ),
    //             SizedBox(height: 20),
    //             Padding(
    //               padding: EdgeInsets.only(
    //                   bottom: MediaQuery.of(context).viewInsets.bottom),
    //               child: TextField()
    //               //richEntryField("Comment", minLines: 3, maxLines: 5),
    //             ),
    //             SizedBox(height: 30),
    //             submitButton(
    //               hint: "Submit",
    //               onSubmit: (){},
    //               context: context
    //             )
    //             // FlatButton(
    //             //   onPressed: (){},
    //             //   child: Text("Submit"),
    //             //   color: Theme.of(context).primaryColor,
    //             // )
    //           ]
    //         ),
    //       ),
    //     );
    //   }
    // );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Rating>>(
      stream: getFeedbackForUser(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Expanded(
          // height: 100,
          child: ListView(
            children: [
              canReview ? OutlinedButton(
                onPressed: (){
                  _bottomSheet(context);
                },
                child: Text("Leave Feedback"),
                style: ButtonStyle(
                  
                ),
                // textColor: Theme.of(context).primaryColor,
                // color: Theme.of(context).primaryColor,
              ) : SizedBox(),

              ...snapshot.data.map(
                (feedback) {
                  return FeedbackCard(uid: feedback.uid, comment: feedback.comment, timeStamp: feedback.timestamp, rating: feedback.rating,);
                }
                
              ).toList(),
              // FeedbackCard(),
              // FeedbackCard(),
              // FeedbackCard(),

            ]
          ),
        );
      }
    );
  }
}