import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import '../../../models/Product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';
import '../../models/Listing.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key key,
    @required this.listing
  }) : super(key: key);
  // static String routeName = "/details";
  final Listing listing;

  @override
  Widget build(BuildContext context) {
    // final ProductDetailsArguments agrs =
    //     ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CupertinoNavigationBar(
        middle: Text(""),
        backgroundColor: Colors.transparent
      ),
      // CustomAppBar(rating: 3),
      body: SingleChildScrollView(child: Body(listing: listing,)),
    );
  }
}

class ListingDetailsArguments {
  final Listing listing;

  ListingDetailsArguments({@required this.listing});
}
