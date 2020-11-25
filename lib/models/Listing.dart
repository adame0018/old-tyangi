import 'package:flutter/material.dart';
class Listing {
  String id;
  String title, description, price, zipCode, uid;
  bool autoRepost;
  List<dynamic> images;

  Listing({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.zipCode,
    @required this.uid,
    @required this.autoRepost,
    @required this.images,
  });

  Listing.fromJson(Map<String, dynamic> map){
    if(map== null){
      return;
    }
    id = map['id'];
    title = map['title'];
    description = map['description'];
    price = map['price'];
    zipCode = map['zipCode'];
    uid = map['uid'];
    autoRepost = map['autoRepost'];
    if(map['images'] != null){
      images = List<dynamic>();
      images.addAll(map['images']);
    }
  }

  toJson(){

    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'zipCode': zipCode,
      'autoRepost': autoRepost,
      'uid': uid,
      'images': images
    };
  }
  
}
