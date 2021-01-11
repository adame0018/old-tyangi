import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

getZipCodes() async{
  final myData = await rootBundle.loadString('assets/zips.json');
    List jsonData = json.decode(myData);
    var result = jsonData.singleWhere((element) => element['zip code'] == '35006');
    double startLatitude = result['latitude'];
    double startLongitude = result['longitude'];
    List zipCodes = List();
    jsonData.forEach(
      (element) { 
        if (Geolocator.distanceBetween(startLatitude, startLongitude, element['latitude'].toDouble(), element['longitude'].toDouble()) < 48280.3){
          zipCodes.add(element['zip code']);
        }

      });
}