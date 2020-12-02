import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Rating {
  final String id;
  final String uid;
  final double rating;
  final String comment;
  // final String userName;
  final Timestamp timestamp;

  final DocumentReference reference;

  Rating.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        rating = snapshot.data()['rating'].toDouble(),
        comment = snapshot.data()['comment'],
        // userName = snapshot.data()['userName'],
        uid = snapshot.data()['uid'],
        timestamp = snapshot.data()['timestamp'],
        reference = snapshot.reference;

  Rating.fromUserInput({this.rating, this.comment, this.uid})
      : id = null,
        timestamp = null,
        reference = null;

  // factory Review.random({String userName, String userId}) {
  //   final rating = Random().nextInt(4) + 1;
  //   final review = getRandomReviewcomment(rating);
  //   return Review.fromUserInput(
  //       rating: rating.toDouble(),
  //       comment: review,
  //       userName: userName,
  //       userId: userId);
  // }
}
