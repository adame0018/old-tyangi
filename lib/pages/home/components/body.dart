import 'package:Tyangi/pages/home/components/categories.dart';
import 'package:Tyangi/pages/home/components/featuredListings.dart';
import 'package:flutter/material.dart';
import '../../../models/Listing.dart';

class Body extends StatelessWidget {
  Body({
    @required this.categories,
    @required this.featuredListings
  });
  final List<String> categories;
  final List<Listing> featuredListings;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Categories(categories: categories),
            
            FeaturedListings(listings: featuredListings, title: "Featured"),
            SizedBox(
              height:25,
            ),
            FeaturedListings(listings: featuredListings, title: "Popular",),
            SizedBox(
              height:25,
            ),
            FeaturedListings(listings: featuredListings, title: "Premium")
          ],
        ),
      ),
    );
  }
}