import 'package:flutter/material.dart';
import 'package:trainshop/view/admin/advertise/horizontal_ad_item.dart';

class HorizontalAdGallery extends StatefulWidget {
  const HorizontalAdGallery({Key? key}) : super(key: key);

  @override
  _HorizontalAdGalleryState createState() => _HorizontalAdGalleryState();
}

class _HorizontalAdGalleryState extends State<HorizontalAdGallery> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        //maxCrossAxisExtent: 900,
        mainAxisExtent: 360,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return const HorizontalAdItem();
      },
    );
  }
}
