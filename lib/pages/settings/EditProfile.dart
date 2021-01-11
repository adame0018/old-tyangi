import 'dart:typed_data';

import 'package:Tyangi/models/appUser.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:Tyangi/widgets/Inputs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AppUser user;
  TextEditingController locationController;
  Asset image;
  String _error;
  Uint8List imageData;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    locationController = TextEditingController();
    loadCurrentUser();
    super.initState();
  }

  Future<void> loadAssets() async {
    // setState(() {
    //   images = List<Asset>();
    // });

    List<Asset> resultList=List<Asset>();
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if(resultList.isNotEmpty){
        image = resultList[0];
        image.getByteData().then(
          (value){
            setState(() {
              imageData = value.buffer.asUint8List();
            });
          });
      }
      if (error == null) _error = 'No Error Dectected';
    });
  }

  loadCurrentUser(){
    getUserFromId(FirebaseAuth.instance.currentUser.uid).then(
      (value){
        setState(() {
          user = value;
          locationController.text = user.zipCode;
        });
      });
  }

  Future<String> uploadImage(Asset asset) async{
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    Reference ref = FirebaseStorage.instance.ref().child("Users/${user.uid}/");
    UploadTask task = ref.putData(imageData);
    TaskSnapshot snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  showSnackbar(message){
    _key.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      )
    );
  }

  onSave()async{
    
    if(locationController.text.isEmpty){
      showSnackbar("Zip Code cannot be empty");
      return;
    }
    setState(() {
      isLoading = true;
    });
    if(image!=null){
      String imageURL = await uploadImage(image);
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'profilePic': imageURL
      });
    }
    if(locationController.text != user.zipCode){
      var geoPoint = await getGeoPointFromZip(locationController.text);
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'zipCode': locationController.text,
        'position': geoPoint.data
      });
    }
    if(mounted){
      setState(() {
      isLoading = false;
    });
    }
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        
      ),
      body: user!=null ? 
        OrientationBuilder(
          builder: (context, orientation) {
            return SingleChildScrollView(
                  child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: _height/30),
                  AspectRatio(
                    aspectRatio: orientation == Orientation.portrait ? 3 : 7,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageData != null ?MemoryImage(imageData)
                          :
                          CachedNetworkImageProvider(
                            // "https://loremflickr.com/640/360"
                            user.profilePic??"https://firebasestorage.googleapis.com/v0/b/tyangi-18c2e.appspot.com/o/PngItem_4212617.png?alt=media&token=f350715b-249e-4316-94a1-e19083c38dc4"
                          ),
                          fit: BoxFit.contain
                        )
                      ),
                      )
                      
                    ),
                  SizedBox(height: _height/40,),
                  OutlinedButton(
                    onPressed: loadAssets, 
                    child: Text("Pick Image")
                  ),
                  SizedBox(height: _height/40,),
                  Row(
                    children: [
                      Text(
                        "Zip Code",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ],
                  ),
                  entryField(
                    "",
                    controller: locationController,
                    isNumeric: true
                  ),
                  submitButton(
                    context: context,
                    hint: "Save",
                    isLoading: isLoading,
                    onSubmit: onSave
                  )
                ]
              ),
            ),
      );
          }
        ) : Center(child: CircularProgressIndicator()),
      
    );
  }
}