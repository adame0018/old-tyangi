import 'package:Tyangi/widgets/Inputs.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddListing extends StatefulWidget {
  @override
  _AddListingState createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String category;
  String subCategory;
  String condition;
  String contactOption;
  List<String> categories = List();
  List<dynamic> subCategories = List();
  List<Asset> images = List<Asset>();
  String _error;
  DateTime pickedDate;
  TimeOfDay time;
  bool autoRepost = false;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  TextEditingController _locationController;
  Map<String, FocusNode> focusNodes = {
    'title': FocusNode(),
    'category': FocusNode(debugLabel: "category"),
    'subCategory': FocusNode(debugLabel: "subcategory"),
    'description': FocusNode(),
    'price': FocusNode(),
    'condition': FocusNode(),
    'location': FocusNode(),
    'contactOption': FocusNode(),
  } ;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  // var imagesURL;

  Future<void> loadAssets() async {
    // setState(() {
    //   images = List<Asset>();
    // });

    List<Asset> resultList=List<Asset>();
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images.addAll(resultList);
      if (error == null) _error = 'No Error Dectected';
    });
  }

  void loadCategories() async {
    
    var tempCategories = await getCategories();
    setState(() {
      categories.addAll(tempCategories);
    });
    
    print(categories);
    
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadSubCategories() async {
    // setState(() {
      
      

    //     FirebaseFirestore.instance.collection('Categories/$category/subCategories').get().then(
    //       (value) => value.docs.forEach(
    //         (element) {
    //             subCategories.add(element.id);
    //         }
    //       ));
    //       subCategories.toSet();
      
    // });
    //var documents = await FirebaseFirestore.instance.collection('Categories/$category/subCategories').get();
     var tempSubCategories;
     tempSubCategories = await getSubCategories(category);
      setState(() {
        print(tempSubCategories);
        subCategories.clear();
        subCategories.addAll(tempSubCategories);
      });
    
  }

  _pickDate() async {
   DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: DateTime.now(),
    );
    if(date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _pickTime() async {
   TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now()
    );
    if(t != null)
      setState(() {
        time = t;
      });
  }

  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'UNDO', onPressed: _scaffoldKey.currentState.hideCurrentSnackBar),
    );
    _scaffoldKey.currentState.showSnackBar(snackBarContent);
  }

  Future<String> uploadImage(Asset asset, int index, String listingId) async{
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    Reference ref = FirebaseStorage.instance.ref().child("Listings/$listingId/$index/");
    UploadTask task = ref.putData(imageData);
    TaskSnapshot snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  Future<List<String>> saveImage(List<Asset> images, String listingId) async {
    List<String> imagesURL = List<String>();
    int index = 0;
    imagesURL = await Future.wait(
      images.map((asset){
        index++;
        return uploadImage(asset, index, listingId);
      })
    );
    // print(imagesURL);
    return imagesURL;
    // images.forEach((asset) async {
    //   index++;
    //   ByteData byteData = await asset.getByteData();
    //   List<int> imageData = byteData.buffer.asUint8List();
    //   Reference ref = FirebaseStorage.instance.ref().child("Listings/$index/");
    //   UploadTask task = ref.putData(imageData);
    //   TaskSnapshot snapshot = await task;
    //   String url = await snapshot.ref.getDownloadURL();
    //   imagesURL.add(url);
    // });
    // return await imagesURL;
    // int index =0;
      // imagesURL = images.map((asset) async { 
      //     index++;
      //     ByteData byteData = await asset.getByteData(); // requestOriginal is being deprecated
      //     List<int> imageData = byteData.buffer.asUint8List();
      //     Reference ref = FirebaseStorage.instance.ref().child("Listings/$index/"); // To be aligned with the latest firebase API(4.0)
      //     TaskSnapshot task = await ref.putData(imageData);
      //     String url = await task.ref.getDownloadURL();
      //     return await url;
      //     // ref.putData(imageData).then(
      //     //   (task) {
      //     //     task.ref.getDownloadURL().then(
      //     //       (url) {
      //     //         return url;
      //     //       }
      //     //     );
      //     //   }
      //     // );
      // }).toList();// use putfile and get the listing id

    // return (imagesURL);


      // return await (await uploadTask.whenComplete).ref.getDownloadURL();
  }

  void onSubmit() async {
    if(
      _titleController.text == null || _titleController.text.isEmpty ||
      _descriptionController.text == null || _descriptionController.text.isEmpty ||
      _priceController.text == null || _priceController.text.isEmpty ||
      _locationController.text == null || _locationController.text.isEmpty ||
      category.isEmpty || subCategory.isEmpty || (autoRepost && (pickedDate == null || time == null))
    ){
      showSnackBar("Please fill All the fields");
      return;
    }
    else {
      try{

        setState(() {
          isLoading = true;
        });
        // print(imagesURL);
        String listingId;
        if(autoRepost){
           listingId = await postListing(title: _titleController.text, 
            description: _descriptionController.text, 
            price: _priceController.text,
            autoRepost: autoRepost,
            category: category,
            subCategory: subCategory,
            autoRepostAt: pickedDate.add(Duration(hours: time.hour, minutes: time.minute))
          );
        }else {
          listingId = await postListing(title: _titleController.text, 
            description: _descriptionController.text, 
            price: _priceController.text,
            autoRepost: autoRepost,
            category: category,
            subCategory: subCategory,
          );
        }
        print(listingId);
        List<String> imagesURL = await saveImage(images, listingId);
        
          
          await firestore.collection('Listings').doc(listingId).update({
            'images': imagesURL,
            'id': listingId
          });
        
        // print("reference"+docRef);
        // print(imagesURL);
        setState(() {
          isLoading=false;
        });
        showSnackBar("Listing posted");
      } catch(e){
        showSnackBar("an error occured");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget autoRepostWidget(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          offset: Offset(1, 2),
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 3.0,
          spreadRadius: 1.0
        )]
      ),
      child: 
          
          Column(
            children: [
              Row(
                children: [
                  Checkbox(value: autoRepost, onChanged:(newValue){
                        setState(() {
                          autoRepost = newValue;
                        });
                      }),
                    
                  
                  
                Text("Auto Repost",
                      style: TextStyle(fontSize: 18),
                  ),
                  
                ],
              ),
              autoRepost ? 
              Column(
                children: [ListTile(
                title: pickedDate==null?Text("Date"):Text("Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickDate,
              ),
              ListTile(
                title: time==null?Text("Time"):Text("Time: ${time.hour}:${time.minute}"),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickTime,
              )]
              ): SizedBox(),
            ],
          ),
        
    );
}

  @override
  void initState() {
    // TODO: implement initState
    loadCategories();
    images = List<Asset>();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _locationController = TextEditingController();
    // pickedDate = DateTime.now();
    // time = TimeOfDay.now();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CupertinoColors.secondarySystemBackground,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        previousPageTitle: "Home",
        middle: Text(
          "Add Listing",
          style: TextStyle(
            color: Colors.blue
          ),
        ),
        // leading: Icon(
        //   Icons.arrow_back_ios,
        //   color: CupertinoColors.systemBlue,
        // ),
      ),
      body: GestureDetector(
        onTap: (){
          focusNodes.forEach((key, node) { 
            node.unfocus();
          });
          },
         child: SingleChildScrollView(
           child: Container(
             padding: EdgeInsets.symmetric(horizontal: 20),
             child: 
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        entryField("Title", 
                        focusNode: focusNodes['title'], 
                        fontWeight: FontWeight.bold,
                        controller: _titleController
                        ),
                        entryField("Price", isNumeric: true, 
                          prefixIcon: Icon(CupertinoIcons.money_dollar), 
                          focusNode: focusNodes['price'],
                          controller: _priceController
                          ),
                          entryField("Location", isNumeric: true, 
                          prefixIcon: Icon(Icons.location_on_outlined), 
                          focusNode: focusNodes['location'],
                          controller: _locationController
                          ),
                          dropDown(
                          focusNode: focusNodes['condition'],
                          hint: "Condition", 
                          value: condition,
                          items: ["New","Used-Like New", "Used-Good", "Used-Fair"],
                          onChanged: (item) {
                              setState(() {
                                condition = item;
                              });
                              
                            
                          },
                        ),
                        autoRepostWidget(),
                        dropDown(
                          focusNode: focusNodes['contactOption'],
                          hint: "Contact Options", 
                          value: contactOption,
                          items: ["Chat", "Phone"],
                          onChanged: (item) {
                              setState(() {
                                contactOption = item;
                              });
                              
                            
                          },
                        ),
                        dropDown(
                          focusNode: focusNodes['category'],
                          hint: "Category", 
                          value: category,
                          items: categories,
                          onChanged: (item) {
                              setState(() {
                                category = item;
                              });
                              loadSubCategories();
                            
                          },
                        ),
                        dropDown(
                          focusNode: focusNodes['subCategory'],
                          hint: "Sub Category",
                          value: subCategory,
                          items: subCategories,
                          onChanged: (item) {
                            setState(() {
                              subCategory = item;
                            });
                          }
                        ),
                        richEntryField("Description", 
                          focusNode: focusNodes['description'], 
                          minLines: 3, maxLines: 50,
                          controller: _descriptionController
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom:8.0),
                          child: Text("Photos",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      
                        SingleChildScrollView(
                          child: Row(
                            children : [
                              GestureDetector(
                                  onTap: loadAssets,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    width: 80,
                                    height: 80,
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.white,
                                    )
                                  ),
                                ),
                                ...List.generate((images.length), (index) {
                              
                                  Asset asset = images[index];
                                  return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: AssetThumb(
                                      asset: asset,
                                      width: 80,
                                      height: 80,
                                    ),
                                  );
                                }),
                            ]
                            // children: List.generate((images!=null?images.length+1:1), (index) {
                            //   if(index==images.length){
                            //     return GestureDetector(
                            //       onTap: loadAssets,
                            //       child: Container(
                            //         decoration: BoxDecoration(
                            //           color: Colors.grey,
                            //           borderRadius: BorderRadius.all(Radius.circular(20)),
                            //         ),
                            //         width: 80,
                            //         height: 80,
                            //         child: Icon(
                            //           Icons.add_a_photo_outlined,
                            //           color: Colors.white,
                            //         )
                            //       ),
                            //     );
                            //   }
                            //   Asset asset = images[index];
                            //   return Container(
                            //     padding: const EdgeInsets.all(8.0),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(20)
                            //     ),
                            //     child: AssetThumb(
                            //       asset: asset,
                            //       width: 80,
                            //       height: 80,
                            //     ),
                            //   );
                            // }),
                          ),
                          scrollDirection: Axis.horizontal,
                        ),
                        
                        submitButton(hint: "Add", context: context, onSubmit: onSubmit, isLoading: isLoading)
                        
                      ]
                    )
                  
           ),
         )
        ),
    );
  }
}

