import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Listing {
  String id;
  String title, description, price, zipCode, uid, category, subCategory, contactOption, condition;
  bool autoRepost, sold;
  List<dynamic> images;
  Timestamp createdAt, repostAt, expirationTime;
  Map<String, dynamic> position;

  Listing({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.zipCode,
    @required this.uid,
    @required this.autoRepost,
    @required this.images,
    @required this.category,
    @required this.subCategory,
    @required this.createdAt,
    @required this.repostAt,
    @required this.contactOption,
    @required this.condition,
    @required this.position,
    this.expirationTime,
    this.sold
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
    category = map['category'];
    subCategory = map['subCategory'];
    createdAt = map['createdAt'];
    repostAt = map['repostAt'];
    contactOption = map['contactOption'];
    condition = map['condition'];
    position = map['position'];
    expirationTime = map['expirationTime'];
    if(map['sold']!= null){
      sold = map['sold'];
    } else{
      sold = false;
    }
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
      'images': images,
      'category': category,
      'subCategory': subCategory,
      'createdAt': createdAt,
      'repostAt': repostAt,
      'contactOption': contactOption,
      'condition': condition,
      'position': position,
      'expirationTime': expirationTime,
      'sold': sold??false,
    };
  }
  
}
