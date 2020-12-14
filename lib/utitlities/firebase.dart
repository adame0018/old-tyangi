import 'dart:convert';

import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/models/rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../models/Listing.dart';
import 'package:http/http.dart' as http;

Future<void> setupUser({String name, String email, String contact, String zipCode, GeoFirePoint geoPoint}) async {
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  CollectionReference reference = FirebaseFirestore.instance.collection('Users');
  await reference.doc(uid).set({
    'uid': uid,
    'email': email,
    'name': name,
    'contact': contact,
    'zipCode': zipCode,
    'profilePic': 'https://firebasestorage.googleapis.com/v0/b/tyangi-18c2e.appspot.com/o/PngItem_4212617.png?alt=media&token=f350715b-249e-4316-94a1-e19083c38dc4',
    'avgRating': 0,
    'numRatings': 0,
    'position': geoPoint.data,
    'repostTokens': 3
  });
  return;
}

Future<dynamic> getUserZipCode() async{
  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference reference = FirebaseFirestore.instance.collection('Users');
  var doc = await reference.doc(uid).get();
  var userData = doc.data();
  return userData['zipCode'];
}

Future<String> getUserName() async{
  String name;
  String uid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference reference = FirebaseFirestore.instance.collection('Users');
  var doc = await reference.doc(uid).get();
  var userData = doc.data();
  name = userData['name'];
  return name;
}

Future<GeoFirePoint>getUserGeoPoint(String uid)async{
  var user = await getUserFromId(uid);
  GeoFirePoint geoPoint = Geoflutterfire().point(latitude: user.position['geopoint'].latitude, longitude: user.position['geopoint'].longitude);
  return geoPoint;
}

String getZipCodeAPIKey() {
  return 'CykCSSAevR7sVckyegrSwJAZI3oTDavz';
}

Future<GeoFirePoint> getGeoPointFromZip(String zipCode) async{
  GeoFirePoint geoPoint;
  final response = await http.get('http://open.mapquestapi.com/geocoding/v1/address?key=${getZipCodeAPIKey()}&postalCode=$zipCode&maxResults=1&thumbMaps=false');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var result = jsonDecode(response.body);
    var latLong = result['results'][0]['locations'][0]['latLng'];
    var lat = latLong['lat'];
    var long = latLong['lng'];
    geoPoint = Geoflutterfire().point(latitude: lat, longitude: long);
  } else {
    print("Error fetching LatLong of ZipCode");
    geoPoint = Geoflutterfire().point(latitude: 39.78373, longitude: -100.445882);
  }

  return geoPoint;
    
  }

Future<String> postListing({String title, String description, String price, bool autoRepost, 
      String category, String subCategory, DateTime autoRepostAt,
      String zipCode, String condition, String contactOption
      }) async {
  
    String uid  = FirebaseAuth.instance.currentUser.uid;
    var zipCode = await getUserZipCode();
    var geoPoint = await getGeoPointFromZip(zipCode);
    CollectionReference reference = FirebaseFirestore.instance.collection('Listings');
    var docRef = autoRepost ? await reference.add({
      'uid': uid,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'subCategory': subCategory,
      'autoRepost': autoRepost,
      'zipCode': zipCode,
      'createdAt': FieldValue.serverTimestamp(),
      'autoRepostAt': autoRepostAt.toUtc(),
      'position': geoPoint.data,
      'condition': condition,
      'contactOption': contactOption
    }) : 
      await reference.add({
      'uid': uid,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'subCategory': subCategory,
      'autoRepost': autoRepost,
      'zipCode': zipCode,
      'createdAt': FieldValue.serverTimestamp(),
      'autoRepostAt': null,
      'position': geoPoint.data,
      'condition': condition,
      'contactOption': contactOption
    });
    return docRef.id;

  
}

Future<List<String>> getCategories() async{
  List<String> categories = List<String>();
  await FirebaseFirestore.instance.collection("Categories").get().then(
      (value) => value.docs.forEach(
        (e) {
          categories.add(e.id);
          // category = categories[0];
          }
        )
      );
  return categories;
}

Future<List<dynamic>> getSubCategories(String category) async {
  List<dynamic> subCategories = List<dynamic>();
  // await FirebaseFirestore.instance.collection('Categories/$category/subCategories').get().then(
  //   (value) => value.docs.forEach(
  //     (element) {
  //       subCategories.add(element.id);
  //       }
  //     )
  //   );

  await FirebaseFirestore.instance.collection('Categories').doc('$category').get().then(
    (snap) => subCategories.addAll(snap.data()['subCategories']));   
        
  return subCategories;

}

Future<List<Listing>> getListings() async{
  List<Listing> listings = List<Listing>();
  // await FirebaseFirestore.instance.collection('Listings').get().then(
  //   (value) => value.docs.forEach(
  //     (doc) {
  //         listings.add(new Listing.fromJson(doc.data()));
  //      })
  // );
  // return listings;
  var documents = await FirebaseFirestore.instance.collection('Listings').orderBy('createdAt', descending: true).get();
  documents.docs.forEach((doc) async {
    listings.add(new Listing.fromJson(doc.data()));
  });
  return listings;
}

Future<List<Listing>> getListingsBySubCategory({String subCategory}) async{
  List<Listing> listings = List<Listing>();
  var documents = await FirebaseFirestore.instance.collection('Listings').where('subCategory', isEqualTo: subCategory).orderBy('createdAt', descending: true).get();
  documents.docs.forEach((doc) async {
    listings.add(new Listing.fromJson(doc.data()));
  });
  return listings;
}

Future<List<Listing>> getListingsByUser({String uid}) async{
  List<Listing> listings = List<Listing>();
  var documents = await FirebaseFirestore.instance.collection('Listings').where('uid', isEqualTo: uid).orderBy('createdAt', descending: true).get();
  documents.docs.forEach((doc) async {
    listings.add(new Listing.fromJson(doc.data()));
  });
  return listings;
}



Future<AppUser> getCurrentUser() async {
  User currentUser = FirebaseAuth.instance.currentUser;
  var snapshot = await FirebaseFirestore.instance.collection('Users').doc(currentUser.uid).get();
  var user = AppUser.fromJson(snapshot.data());
  return user;
}

Future<AppUser> getUserFromId(String uid) async {

  var snapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  print("asnda");
  print(snapshot.exists);
  print(snapshot.data());
  var user = AppUser.fromJson(snapshot.data());
  return user;
}

Future<void> addRating({String uid, Rating rating}) {
  final user =
      FirebaseFirestore.instance.collection('Users').doc(uid);
  final newReview = user.collection('ratings').doc();

  return FirebaseFirestore.instance.runTransaction((Transaction transaction) {
    return transaction
        .get(user)
        .then((DocumentSnapshot doc) => AppUser.fromJson(doc.data()))
        .then((AppUser fresh) {
      final newRatings = fresh.numRatings + 1;
      final newAverage =
          ((fresh.numRatings * fresh.avgRating) + rating.rating) / newRatings;

      transaction.update(user, {
        'numRatings': newRatings,
        'avgRating': newAverage,
      });

      transaction.set(newReview, {
        'rating': rating.rating,
        'comment': rating.comment,
        'timestamp': rating.timestamp ?? FieldValue.serverTimestamp(),
        'userId': rating.uid,
      });
    });
  });
}

Stream<List<Rating>> getFeedbackForUser(String uid) {
  // List<Rating> feedbacks = List<Rating>();
  // var documents = await FirebaseFirestore.instance.collection('Users/$uid/ratings').get();
  // documents.docs.forEach((doc) async {
  //   feedbacks.add(new Rating.fromSnapshot(doc));
  // });
  // return feedbacks;
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('Users/$uid/ratings').snapshots();

    return stream.map(
      (qShot) => qShot.docs.map(
        (doc) => Rating.fromSnapshot(
              doc  
            )
      ).toList()
    );
}

// Future<List<Listing>> getListingsWithLimit() async{
//   List<Listing> listings = List<Listing>();
//   // await FirebaseFirestore.instance.collection('Listings').get().then(
//   //   (value) => value.docs.forEach(
//   //     (doc) {
//   //         listings.add(new Listing.fromJson(doc.data()));
//   //      })
//   // );
//   // return listings;
//   var documents = await FirebaseFirestore.instance.collection('Listings').get();
//   documents.docs.forEach((doc) async {
//     listings.add(new Listing.fromJson(doc.data()));
//   });
//   return listings;
// }