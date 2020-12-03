import 'package:Tyangi/pages/subCategory/ListingsBySubCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../utitlities/firebase.dart';
import '../../utitlities/firebase.dart';

class SubCategories extends StatefulWidget {
  String category;
  SubCategories(this.category);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  // List<dynamic> subCategories = List<dynamic>();

  // _loadSubCategories() async {
  //   var temp = await getSubCategories(widget.category);
  //   setState(() {
  //     subCategories.addAll(temp);
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    // _loadSubCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          "Select Sub Category"
        ),
        previousPageTitle: "Home",
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getSubCategories(widget.category),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
            var subCategories = snapshot.data;
            return ListView.builder(
                    itemCount: subCategories.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (_) => ListingsBySubCategory(subCategory: subCategories[index])
                          ));
                        },
                        child: Container(
                          height: 55,
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                         // padding: EdgeInsets.symmetric(vertical: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withAlpha(50)
                          ),
                          child: Center(
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              title: Text(
                                subCategories[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: 20,),
                            ),
                          ),
                        ),
                      );
                    }
                    
                  );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}

// class SubCategories extends StatelessWidget {
//   SubCategories({
//     String category,
//   });
//   String category;

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: CupertinoNavigationBar(
//         middle: Text(
//           "Select Sub Category"
//         ),
//         previousPageTitle: "Home",
//       ),
//       body: 
//       // ListView.builder(
//       //           itemCount: subCategories.length,
//       //           itemBuilder: (context, index){
//       //             return Container(
//       //               height: 55,
//       //               margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       //              // padding: EdgeInsets.symmetric(vertical: 0),
//       //               decoration: BoxDecoration(
//       //                 borderRadius: BorderRadius.circular(12),
//       //                 color: Colors.grey.withAlpha(50)
//       //               ),
//       //               child: Center(
//       //                 child: ListTile(
//       //                   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//       //                   title: Text(
//       //                     subCategories[index],
//       //                     style: TextStyle(
//       //                       fontWeight: FontWeight.w600
//       //                     ),
//       //                   ),
//       //                   trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: 20,),
//       //                 ),
//       //               ),
//       //             );
//       //           }
                
//       //         )
      
//       FutureBuilder(
//           future: getSubCategories("For Sale"),
//           builder: (context, snapshot){
//             if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
//               // var subCategories = snapshot.data;
//               return ListView.builder(
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (context, index){
//                   return Container(
//                     height: 55,
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                    // padding: EdgeInsets.symmetric(vertical: 0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Colors.grey.withAlpha(50)
//                     ),
//                     child: Center(
//                       child: ListTile(
//                         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//                         title: Text(
//                           snapshot.data[index],
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600
//                           ),
//                         ),
//                         trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: 20,),
//                       ),
//                     ),
//                   );
//                 }
                
//               );
//             }
//             else return Center(child: CircularProgressIndicator());
//           }
        
//         )
      
//     );
//   }
// }