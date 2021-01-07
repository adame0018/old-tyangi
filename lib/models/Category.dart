import 'package:flutter/material.dart';
class Category {
  String name, productIdentifier;
  bool isPaid;
  List subCategories;


  Category({
   @required this.name,
   @required this.isPaid,
   @required this.subCategories
  });

  Category.fromJson(Map<String, dynamic> map){
    if(map== null){
      return;
    }
    name = map['name'];
    isPaid = map['isPaid'];
    productIdentifier = map['productIdentifier'];

    if(map['subCategories'] != null){
      subCategories= List<dynamic>();
      subCategories.addAll(map['subCategories']);
    }
  }

  toJson(){

    return {
      'name': name,
      'isPaid': isPaid,
      'subCategories': subCategories,
      'productIdentifier': productIdentifier
    };
  }
  
}