import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Listing.dart';

Future<void> setupUser({String name, String email, String contact, String zipCode}) async {
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  CollectionReference reference = FirebaseFirestore.instance.collection('Users');
  await reference.doc(uid).set({
    'uid': uid,
    'email': email,
    'name': name,
    'contact': contact,
    'zipCode': zipCode,
    'profilePic': null,
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

Future<String> postListing({String title, String description, String price, bool autoRepost, String category, String subCategory}) async {
  String uid  = FirebaseAuth.instance.currentUser.uid;
  var zipCode = await getUserZipCode();
  CollectionReference reference = FirebaseFirestore.instance.collection('Listings');
  var docRef = await reference.add({
    'uid': uid,
    'title': title,
    'description': description,
    'price': price,
    'category': category,
    'subCategory': subCategory,
    'autoRepost': autoRepost,
    'zipCode': zipCode,
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

Future<List<String>> getSubCategories(String category) async {
  List<String> subCategories = List<String>();
  await FirebaseFirestore.instance.collection('Categories/$category/subCategories').get().then(
    (value) => value.docs.forEach(
      (element) {
        subCategories.add(element.id);
        }
      )
    );
     
        
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
  var documents = await FirebaseFirestore.instance.collection('Listings').get();
  documents.docs.forEach((doc) async {
    listings.add(new Listing.fromJson(doc.data()));
  });
  return listings;
}