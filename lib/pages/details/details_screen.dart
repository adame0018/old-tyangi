import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';
import '../../models/Listing.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key key,
    @required this.listing,
    @required this.pageTag
  }) : super(key: key);
  // static String routeName = "/details";
  final Listing listing;
  final String pageTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CupertinoNavigationBar(
        middle: Text(""),
        backgroundColor: Colors.transparent
      ),
      // CustomAppBar(rating: 3),
      body: SingleChildScrollView(child: Body(listing: listing,pageTag: pageTag,)),
    );
  }
}

class ListingDetailsArguments {
  final Listing listing;

  ListingDetailsArguments({@required this.listing});
}
