import 'package:flutter/material.dart';

class AppUser{
  String uid, email, name, profilePic, zipCode, contact;
  int numRatings, repostTokens;
  double avgRating;
  dynamic position;

  AppUser({
    @required this.uid,
    @required this.email,
    @required this.name,
    @required this.profilePic,
    @required this.zipCode,
    @required this.contact,
    @required this.position,
    @required this.repostTokens,
    this.avgRating = 0,
    this.numRatings = 0,
  });

  AppUser.fromJson(Map<String, dynamic> map){
    if(map== null){
      return;
    }
    uid = map['uid'];
    name = map['name'];
    email = map['email'];
    contact = map['contact'];
    zipCode = map['zipCode'];
    profilePic = map['profilePic'];
    numRatings = map['numRatings'];
    avgRating = map['avgRating'].toDouble();
    position = map['position'];
    repostTokens = map['repostTokens'];
  }

  toJson(){

    return {
      'uid': uid,
      'email': email,
      'name': name,
      'contact': contact,
      'zipCode': zipCode,
      'profilePic': profilePic,
      'numRatings': numRatings,
      'avgRating': avgRating,
      'position': position,
      'repostTokens': repostTokens
    };
  }
}