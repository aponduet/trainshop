import 'package:flutter/material.dart';
import 'package:trainshop/controller/responsive/responsive.dart';

class ImageBanner extends StatelessWidget {
  String title;
  String subtitle;
  Icon icon;
  double titlefontsize;
  double subtitlefontsize;
  double bannerwidth;

  ImageBanner(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.titlefontsize,
      required this.subtitlefontsize,
      required this.bannerwidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerWidth = Responsive.width(context);
    print(bannerwidth);
    List<Widget> children = <Widget>[
      Container(
        child: icon,
      ),
      const SizedBox(
        width: 10,
      ),
      Text(
        title,
        style: TextStyle(
            fontSize: titlefontsize,
            fontWeight: FontWeight.w900,
            color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      width: Responsive.value(
          containerWidth * 0.9,
          containerWidth * 0.9 < 600.0 ? containerWidth * 0.9 : 600.0,
          600.0,
          context),
      //height:Responsive.height(context) < 450 ? Responsive.height(context) : 450,
      height: Responsive.height(context),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: subtitlefontsize,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
