import 'package:flutter/material.dart';
// import 'package:shop_app/models/Product.dart';

// import '../../../constants.dart';
import '../../../utitlities/sizeConfig.dart';
import '../../../models/Listing.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.listing,
  }) : super(key: key);

  // final Product product;
  final Listing listing;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  var images = [
    "http://via.placeholder.com/640x360",
    "https://loremflickr.com/640/360"
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: Hero(
            tag: widget.listing.id,
            child: Image.network(widget.listing.images[selectedImage], fit: BoxFit.contain,),
          ),
        ),
         SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.listing.images.length,
                (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.listing.images[index]),
      ),
    );
  }
}
